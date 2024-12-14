import 'package:biteflow/core/providers/user_provider.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/models/cart.dart';
import 'package:biteflow/models/menu_item.dart';
import 'package:biteflow/services/firestore/cart_service.dart';
import 'package:biteflow/services/navigation_service.dart';
import 'package:biteflow/viewmodels/base_model.dart';
import 'package:biteflow/views/screens/cart/cart_view.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class CartViewModel extends BaseModel {
  final _navigationService = getIt<NavigationService>();
  final _userProvider = getIt<UserProvider>();
  final _cartService = getIt<CartService>();
  final _logger = getIt<Logger>();

  Stream<Cart>? _cartStream;
  Stream<Cart>? get cartStream => _cartStream;

  Cart? _cart;
  Cart get cart => _cart!;
  set setCart(Cart? cart) {
    if (cart != _cart) {
      _cart = cart;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  String? _filterUserId;
  String? get filterUserId => _filterUserId;

  bool _isFilterOpen = false;
  bool get isFilterOpen => _isFilterOpen;
  void toggleFilterOpen() {
    _isFilterOpen = !_isFilterOpen;
  }

  bool get isReady =>
      _cart!.participants
          .firstWhere((p) => p.id == _userProvider.user!.id)
          .status ==
      ParticipantStatus.done;

  bool checkAllParticipantsDone() {
    String creatorId = _cart!.creatorId;

    bool allDone = _cart!.participants
        .where((participant) => participant.id != creatorId)
        .every((participant) => participant.status == ParticipantStatus.done);

    return allDone;
  }

  bool get isCreator => cart.creatorId == _userProvider.user!.id;

  List<CartItem> _filteredItems = [];
  List<CartItem> get filteredItems => _filteredItems;
  set setFilteredItems(filteredItems) {
    _filteredItems = filteredItems;
  }

  List<CartItem> applyFilter(List<CartItem> items) {
    return items.where((item) {
      return _filterUserId == null ||
          (item.participants.any((participant) =>
              participant.id == _filterUserId &&
              participant.status == ParticipantStatus.done));
    }).toList();
  }

  void setFilter(String? userId) {
    _filterUserId = userId;
    notifyListeners();
  }

  void joinCart(String cartId) async {
    _cartStream = _cartService.listenToCartUpdates(cartId);
    CartParticipant participant = CartParticipant(
        id: _userProvider.user!.id, name: _userProvider.user!.name);
    await _cartService.addParticipantToCart(cartId, participant);
  }

  void leaveCart() {
    _cartStream = null;
    _cart = null;
    notifyListeners();
  }

  Future<void> _createNewCart(String restaurantId) async {
    final cartId = _cartService.generateCartId();

    Cart cart = Cart(
      id: cartId,
      creatorId: _userProvider.user!.id,
      restaurantId: restaurantId,
      participants: [],
      items: [],
    );
    final result = await _cartService.createCart(cart);
    if (result.isSuccess) {
      _cart = cart;
      joinCart(cartId);
    } else {
      _logger.e(result.error);
    }
  }

  int _findItem(String itemId) {
    return _cart!.items.indexWhere((item) => item.menuItem.id == itemId);
  }

  CartItem? getItem(String itemId) {
    int idx = _findItem(itemId);
    if (idx == -1) return null;
    return _cart!.items[idx];
  }

  CartItem _createItem(MenuItem menuItem, int quantity, String notes) {
    return CartItem(
      menuItem: menuItem,
      userId: _userProvider.user!.id,
      quantity: quantity,
      notes: notes,
      participants: [
        CartParticipant(
            id: _userProvider.user!.id,
            name: _userProvider.user!.name,
            status: ParticipantStatus.done)
      ],
    );
  }

  void addItem({
    required MenuItem menuItem,
    int quantity = 1,
    String notes = '',
  }) async {
    _navigationService.pop();
    if (_cart == null ||
        menuItem.restaurantId != _cart!.items[0].menuItem.restaurantId) {
      await _createNewCart(menuItem.restaurantId);
    }

    CartItem newItem = _createItem(menuItem, quantity, notes);
    final result = await _cartService.addItemToCart(_cart!.id, newItem);
    if (result.isSuccess) {
      _navigationService.navigateTo(const CartView());
    } else {
      _logger.e(result.error);
    }
  }

  void removeItem(String itemId) async {
    int idx = _findItem(itemId);
    if (idx == -1) return;
    final result = await _cartService.removeItem(_cart!.id, itemId);
    if (result.isSuccess) {
    } else {
      _logger.e(result.error);
    }
  }

  CartItem _findAndUpdateItem(String itemId, {int? quantity, String? notes}) {
    int idx = _findItem(itemId);
    final cartItem = _cart!.items[idx];

    return CartItem(
      menuItem: cartItem.menuItem,
      userId: cartItem.userId,
      participants: cartItem.participants,
      quantity: quantity ?? cartItem.quantity,
      notes: notes ?? cartItem.notes,
    );
  }

  Future<void> updateItemQuantity(String itemId, int quantity) async {
    if (quantity <= 0) {
      removeItem(itemId);
      return;
    }
    CartItem updatedItem = _findAndUpdateItem(itemId, quantity: quantity);
    final result = await _cartService.updateItemInCart(_cart!.id, updatedItem);
    if (result.isSuccess) {
      int idx = _findItem(itemId);
      _cart!.items[idx] = updatedItem;
      notifyListeners();
    } else {
      _logger.e(result.error);
    }
  }

  Future<void> updateItemNotes(String itemId, String notes) async {
    CartItem updatedItem = _findAndUpdateItem(itemId, notes: notes);
    final result = await _cartService.updateItemInCart(_cart!.id, updatedItem);
    if (result.isSuccess) {
      int idx = _findItem(itemId);
      _cart!.items[idx] = updatedItem;
      notifyListeners();
    } else {
      _logger.e(result.error);
    }
  }

  double get totalAmount {
    double total = 0;
    if (_cart != null) {
      for (final item in _cart!.items) {
        if (filterUserId == null || item.userId == filterUserId) {
          total += item.menuItem.price * item.quantity;
        }
      }
    }
    return total;
  }

  void acceptInvitation(String itemId) async {
    int idx = _findItem(itemId);
    if (idx == -1) return; // Item not found

    CartItem updatedItem = _cart!.items[idx];

    // Find the participant and update their status to 'done'
    for (var participant in updatedItem.participants) {
      if (participant.id == _userProvider.user!.id) {
        participant.status = ParticipantStatus.done;
        break;
      }
    }

    // Update the item in the cart
    final result = await _cartService.updateItemInCart(_cart!.id, updatedItem);
    if (result.isSuccess) {
      _cart!.items[idx] = updatedItem;
      _logger.d('notified listeners');
      notifyListeners();
    } else {
      _logger.e(result.error);
    }
  }

  void cancelInvitation(String itemId) async {
    int idx = _findItem(itemId);
    if (idx == -1) return; // Item not found

    CartItem updatedItem = _cart!.items[idx];

    // Remove the participant with the current user's ID
    updatedItem.participants
        .removeWhere((participant) => participant.id == _userProvider.user!.id);

    // Update the item in the cart
    final result = await _cartService.updateItemInCart(_cart!.id, updatedItem);
    if (result.isSuccess) {
      _cart!.items[idx] = updatedItem;
      notifyListeners();
    } else {
      _logger.e(result.error);
    }
  }

  void toggleParticipantStatus() async {
    CartParticipant participant = _cart!.participants.firstWhere(
      (p) => p.id == _userProvider.user!.id,
    );

    participant.status = participant.status == ParticipantStatus.pending
        ? ParticipantStatus.done
        : ParticipantStatus.pending;

    final result = await _cartService.updateParticipantStatus(
        _cart!.id, _userProvider.user!.id, participant.status);

    if (result.isSuccess) {
      notifyListeners();
    } else {
      _logger.e('Error updating participant status: ${result.error}');
    }
  }

  void placeOrder() {
    // TODO FINALLY ORDER IS PLACED !!!!!!!!!!!!!!!!!!!!!!!!!
  }
}
