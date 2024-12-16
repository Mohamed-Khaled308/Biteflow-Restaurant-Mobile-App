import 'package:biteflow/core/providers/user_provider.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/models/cart.dart';
import 'package:biteflow/models/menu_item.dart';
import 'package:biteflow/models/order.dart';
import 'package:biteflow/models/order_clients_payment.dart';
import 'package:biteflow/models/order_item.dart';
import 'package:biteflow/models/order_item_participant.dart';
import 'package:biteflow/services/firestore/cart_service.dart';
import 'package:biteflow/services/firestore/order_service.dart';
import 'package:biteflow/services/navigation_service.dart';
import 'package:biteflow/viewmodels/base_model.dart';
import 'package:biteflow/views/screens/cart/cart_view.dart';
import 'package:flutter/material.dart';

class CartViewModel extends BaseModel {
  final _navigationService = getIt<NavigationService>();
  final _userProvider = getIt<UserProvider>();
  final _cartService = getIt<CartService>();
  final _orderService = getIt<OrderService>();

  Stream<Cart>? _cartStream;
  Stream<Cart>? get cartStream => _cartStream;

  Cart? _cart;
  Cart? get cart => _cart;
  bool get isCartEmpty => _cart == null || cart!.items.isEmpty;
  set setCart(Cart? cart) {
    if (_cart == null ||
        cart!.toJson().toString() != _cart!.toJson().toString()) {
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

  bool get isReady {
    int participantIndex = _cart!.participants.indexWhere(
      (p) => p.id == _userProvider.user!.id,
    );

    if (participantIndex != -1) {
      CartParticipant participant = _cart!.participants[participantIndex];
      return participant.status == ParticipantStatus.done;
    }

    return false;
  }

  bool checkAllParticipantsDone() {
    String creatorId = _cart!.creatorId;

    bool allDone = _cart!.participants
        .where((participant) => participant.id != creatorId)
        .every((participant) => participant.status == ParticipantStatus.done);

    return allDone;
  }

  bool get isCreator =>
      _cart == null ? false : cart!.creatorId == _userProvider.user!.id;

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

  int get cartItemCount {
    int cnt = 0;
    for (var item in cart!.items) {
      cnt += item.quantity;
    }
    return cnt;
  }

  bool isCartOpened = false;
  set setIsCartOpen(bool value) {
    isCartOpened = value;
  }

  void joinCart(String cartId) async {
    _cartStream = _cartService.listenToCartUpdates(cartId);
    CartParticipant participant = CartParticipant(
        id: _userProvider.user!.id, name: _userProvider.user!.name);
    await _cartService.addParticipantToCart(cartId, participant);
    _cart = (await _cartService.getCartById(cartId)).data;
    if (_cart!.isDeleted ||
        !_cart!.participants
            .any((participant) => participant.id == _cart!.creatorId)) {
      cleanUpCart();
    } else {
      notifyListeners();
    }
  }

  Future<void> leaveCart() async {
    CartParticipant participant = _createParticipant();

    if (isCreator) {
      await _handleCreatorLeaving(participant);
    } else {
      await _handleParticipantLeaving(participant);
    }

    cleanUpCart();
  }

  CartParticipant _createParticipant() {
    return CartParticipant(
      id: _userProvider.user!.id,
      name: _userProvider.user!.name,
    );
  }

  Future<void> _handleCreatorLeaving(CartParticipant participant) async {
    await _removeAllParticipants();

    // await _cartService.deleteCart(_cart!.id);
  }

  Future<void> _handleParticipantLeaving(CartParticipant participant) async {
    await _removeParticipantFromItems(participant);

    await _cartService.removeParticipantFromCart(_cart!.id, participant);

    await _removeOwnerItems(participant);
  }

  Future<void> _removeAllParticipants() async {
    for (var participant in _cart!.participants) {
      await _cartService.removeParticipantFromCart(_cart!.id, participant);
    }
  }

  Future<void> _removeParticipantFromItems(CartParticipant participant) async {
    for (var item in _cart!.items) {
      item.participants.removeWhere((p) => p.id == participant.id);

      final result = await _cartService.updateItemInCart(_cart!.id, item);
      if (!result.isSuccess) {}
    }
  }

  Future<void> _removeOwnerItems(CartParticipant participant) async {
    List<CartItem> itemsToRemove = [];

    for (var item in _cart!.items) {
      if (item.userId == participant.id) {
        itemsToRemove.add(item);
      }
    }

    for (var item in itemsToRemove) {
      await removeItem(item.menuItem.id);
    }
  }

  void cleanUpCart() {
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
    } else {}
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
        _cart!.items.isNotEmpty &&
            menuItem.restaurantId != _cart!.items[0].menuItem.restaurantId) {
      if (_cart != null) {
        await leaveCart();
      }
      await _createNewCart(menuItem.restaurantId);
    }
    CartItem newItem = _createItem(menuItem, quantity, notes);
    final result = await _cartService.addItemToCart(_cart!.id, newItem);
    if (result.isSuccess) {
      if (isCartOpened) {
        _navigationService.pop();
      } else {
        _navigationService.navigateTo(const CartView());
        setIsCartOpen = true;
      }
    } else {}
  }

  Future<void> removeItem(String itemId) async {
    int idx = _findItem(itemId);
    if (idx == -1) return;
    _cart!.items.removeAt(idx);
    final result = await _cartService.removeItem(_cart!.id, itemId);
    if (result.isSuccess) {
      notifyListeners();
    } else {}
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
    } else {}
  }

  Future<void> updateItemNotes(String itemId, String notes) async {
    CartItem updatedItem = _findAndUpdateItem(itemId, notes: notes);
    final result = await _cartService.updateItemInCart(_cart!.id, updatedItem);
    if (result.isSuccess) {
      int idx = _findItem(itemId);
      _cart!.items[idx] = updatedItem;
      notifyListeners();
    } else {}
  }

  double getItemDiscount(CartItem item) {
    if (item.menuItem.discountPercentage > 0) {
      return (item.menuItem.price * item.quantity) *
          (item.menuItem.discountPercentage / 100);
    }
    return 0.0;
  }

  double get totalAmount {
    double total = 0;
    double totalDiscount = 0;

    if (_cart != null) {
      for (final item in _cart!.items) {
        if (filterUserId == null) {
          total += item.menuItem.price * item.quantity;
          totalDiscount += getItemDiscount(item);
        } else {
          List<CartParticipant> doneParticipants = item.participants
              .where(
                  (participant) => participant.status == ParticipantStatus.done)
              .toList();

          bool isFilterUserInParticipants = doneParticipants
              .any((participant) => participant.id == filterUserId);

          if (isFilterUserInParticipants) {
            double amountPerUser = item.menuItem.price * item.quantity;
            amountPerUser /= doneParticipants.length;
            final discountPerUser =
                getItemDiscount(item) / doneParticipants.length;
            total += amountPerUser;
            totalDiscount += discountPerUser;
          }
        }

        // Add the item-specific discount to the total discount
      }
    }

    // Apply total discount to the total amount
    return total - totalDiscount;
  }

  double get totalDiscount {
    double totalDiscount = 0;

    if (_cart != null) {
      for (final item in _cart!.items) {
        if (filterUserId == null) {
          // Calculate discount for all items
          totalDiscount += getItemDiscount(item);
        } else {
          List<CartParticipant> doneParticipants = item.participants
              .where(
                  (participant) => participant.status == ParticipantStatus.done)
              .toList();

          bool isFilterUserInParticipants = doneParticipants
              .any((participant) => participant.id == filterUserId);

          if (isFilterUserInParticipants) {
            double discountPerUser =
                getItemDiscount(item) / doneParticipants.length;
            totalDiscount += discountPerUser;
          }
        }
      }
    }

    return totalDiscount;
  }

  void acceptInvitation(String itemId) async {
    int idx = _findItem(itemId);
    if (idx == -1) return;

    CartItem updatedItem = _cart!.items[idx];

    for (var participant in updatedItem.participants) {
      if (participant.id == _userProvider.user!.id) {
        participant.status = ParticipantStatus.done;
        break;
      }
    }

    final result = await _cartService.updateItemInCart(_cart!.id, updatedItem);
    if (result.isSuccess) {
      _cart!.items[idx] = updatedItem;
      notifyListeners();
    } else {}
  }

  void cancelInvitation(String itemId) async {
    int idx = _findItem(itemId);
    if (idx == -1) return; // Item not found

    CartItem updatedItem = _cart!.items[idx];

    updatedItem.participants
        .removeWhere((participant) => participant.id == _userProvider.user!.id);

    final result = await _cartService.updateItemInCart(_cart!.id, updatedItem);
    if (result.isSuccess) {
      _cart!.items[idx] = updatedItem;
      notifyListeners();
    } else {}
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
    } else {}
  }

  double getAmount(CartParticipant participant) {
    double total = 0;

    for (final item in _cart!.items) {
      List<CartParticipant> doneParticipants = item.participants
          .where((p) => p.status == ParticipantStatus.done)
          .toList();

      bool isParticipantInList =
          doneParticipants.any((p) => p.id == participant.id);

      if (isParticipantInList) {
        double amountPerUser = item.menuItem.price *
            (1 - item.menuItem.discountPercentage / 100) *
            item.quantity;

        amountPerUser /= doneParticipants.length;

        total += amountPerUser;
      }
    }

    return total;
  }

  void placeOrder(final splittingMethod) async {
    if (_cart == null) {
      return;
    }
    _filterUserId = null;

    try {
      List<OrderItem> orderItems = _cart!.items.map((cartItem) {
        return OrderItem(
          id: cartItem.menuItem.id,
          title: cartItem.menuItem.title,
          price: cartItem.menuItem.price,
          imageUrl: cartItem.menuItem.imageUrl,
          description: cartItem.menuItem.description,
          rating: cartItem.menuItem.rating,
          categoryId: cartItem.menuItem.categoryId,
          restaurantId: cartItem.menuItem.restaurantId,
          quantity: cartItem.quantity,
          notes: cartItem.notes,
          discountPercentage: cartItem.menuItem.discountPercentage,
          participants: cartItem.participants.map((participant) {
            return OrderItemParticipant(
              userId: participant.id,
              userName: participant.name,
            );
          }).toList(),
        );
      }).toList();

      List<OrderClientsPayment> clientPayments =
          _cart!.participants.map((participant) {
        final amount = splittingMethod == 'equally'
            ? totalAmount / _cart!.participants.length
            : getAmount(participant);
        return OrderClientsPayment(
            userId: participant.id, isPaid: false, amount: amount);
      }).toList();

      final order = Order(
        id: _orderService.generateOrderId(),
        restaurantId: _cart!.restaurantId,
        orderNumber: _generateOrderNumber(),
        totalAmount: totalAmount,
        items: orderItems,
        orderClientsPayment: clientPayments,
        paymentMethod: '',
      );

      final result = await _orderService.placeOrder(order);

      if (result.isSuccess) {
        _cartService.softDeleteCart(_cart!.id);
      } else {}
    } catch (e) {
      // error
    }
  }

  int _generateOrderNumber() {
    final now = DateTime.now();
    return (now.millisecondsSinceEpoch.abs() ~/ 10000) - 173430000;
  }
}
