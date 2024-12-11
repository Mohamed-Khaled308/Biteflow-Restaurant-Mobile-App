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
  get cart => _cart;
  set setCart(cart) {
    _cart = cart;
  }

  void Function(int index)? onItemRemoved;

  void startListeningToCart(String cartId) {
    _logger.d(cartId);
    _cartStream = _cartService.listenToCartUpdates(cartId);
    notifyListeners();
  }

  void addItemToCart({
    required MenuItem menuItem,
    int quantity = 1,
    String note = '',
  }) async {
    CartItem cartItem = CartItem(
      menuItem: menuItem,
      userId: _userProvider.user!.id,
      userName: _userProvider.user!.name,
      quantity: quantity,
      notes: note,
    );
    _navigationService.pop();
    if (_cart == null) {
      _createNewCart(cartItem);
    } else {
      final result = await _cartService.addItemToCart(_cart!.id, cartItem);
      if (result.isSuccess) {
        _navigationService.navigateTo(const CartView());
      } else {
        _logger.e(result.error);
      }
    }
  }

  void _createNewCart(CartItem cartItem) async {
    final cartId = _cartService.generateCartId();
      final cartParticipant = CartParticipant(
        id: _userProvider.user!.id,
        name: _userProvider.user!.name,
      );

      Cart cart = Cart(
        id: cartId,
        restaurantId: cartItem.menuItem.restaurantId,
        participants: [cartParticipant],
        items: [cartItem],
      );

      final result = await _cartService.createCart(cart);
      if (result.isSuccess) {
        startListeningToCart(cartId);
        _navigationService.navigateTo(const CartView());
      } else {
        _logger.e(result.error);
      }
  }

  double get totalAmount {
    double total = 0;
    if (_cart != null) {
      for (final item in _cart!.items) {
        total += item.menuItem.price * item.quantity;
      }
    }
    return total;
  }

  void updateItemQuantity(String itemId, int quantity) async {
    if (quantity <= 0) {
      _removeItem(itemId);
      return;
    }

    CartItem cartItem = _cart!.items.firstWhere((item) =>
        item.menuItem.id == itemId && item.userId == _userProvider.user!.id);

    CartItem updatedItem = CartItem(
      menuItem: cartItem.menuItem,
      userId: cartItem.userId,
      userName: cartItem.userName,
      quantity: quantity,
      notes: cartItem.notes,
    );

    await _cartService.updateItemQuantityInCart(_cart!.id, updatedItem);
  }

  void _removeItem(String itemId) async {
    int index = _cart!.items.indexWhere((item) =>
        item.menuItem.id == itemId && item.userId == _userProvider.user!.id);

    if (index == -1) return;

    onItemRemoved?.call(index);

    await _cartService.removeItem(_cart!.id, itemId);
  }

  void updateItemNotes(String itemId, String notes) async {
    CartItem cartItem = _cart!.items.firstWhere((item) =>
        item.menuItem.id == itemId && item.userId == _userProvider.user!.id);

    CartItem updatedItem = CartItem(
      menuItem: cartItem.menuItem,
      userId: cartItem.userId,
      userName: _userProvider.user!.name,
      quantity: cartItem.quantity,
      notes: notes,
    );

    await _cartService.updateItemNoteInCart(_cart!.id, updatedItem);
  }
}
