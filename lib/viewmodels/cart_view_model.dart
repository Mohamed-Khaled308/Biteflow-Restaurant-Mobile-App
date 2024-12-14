import 'package:biteflow/core/providers/user_provider.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/models/cart.dart';
import 'package:biteflow/models/menu_item.dart';
import 'package:biteflow/services/firestore/cart_service.dart';
import 'package:biteflow/services/navigation_service.dart';
import 'package:biteflow/viewmodels/base_model.dart';
import 'package:biteflow/views/screens/cart/cart_view.dart';
import 'package:logger/logger.dart';

class CartViewModel extends BaseModel {
  final _navigationService = getIt<NavigationService>();
  final _userProvider = getIt<UserProvider>();
  final _cartService = getIt<CartService>();
  final _logger = getIt<Logger>();

  Stream<Cart>? _cartStream;
  Stream<Cart>? get cartStream => _cartStream;

  Cart? _cart;
  Cart? get cart => _cart;
  set setCart(Cart? cart) {
    if (cart != _cart) {
      _cart = cart;
    }
  }

  String? _filterUserId;
  String? get filterUserId => _filterUserId;

  List<CartItem> _filteredItems = [];
  List<CartItem> get filteredItems => _filteredItems;
  set setFilteredItems(filteredItems) {
    _filteredItems = filteredItems;
  }

  List<CartItem> applyFilter(List<CartItem> items) {
    return items
        .where((item) => _filterUserId == null || item.userId == _filterUserId)
        .toList();
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
    return _cart!.items.indexWhere((item) =>
        item.menuItem.id == itemId && item.userId == _userProvider.user!.id);
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
    _logger.d(menuItem.restaurantId);
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

  void updateItemQuantity(String itemId, int quantity) async {
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

  void updateItemNotes(String itemId, String notes) async {
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
}
