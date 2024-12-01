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

  Future<void> startListeningToCart(String cartId) async {
    _cartStream = _cartService.listenToCartUpdates(cartId);
    notifyListeners();
  }

  Future<void> addItemToCart({
    required MenuItem menuItem,
    int quantity = 1,
    String note = '',
  }) async {
    CartItem cartItem = CartItem(
      menuItem: menuItem,
      userId: _userProvider.user!.id,
      quantity: quantity,
      notes: note,
    );
    _navigationService.pop();
    if (_cart == null) {
      // Create a new cart
      final cartId = _cartService.generateCartId();
      final cartParticipant = CartParticipant(
        id: _userProvider.user!.id,
        name: _userProvider.user!.name,
      );

      Cart cart = Cart(
        id: cartId,
        restaurantId: menuItem.restaurantId,
        participants: [cartParticipant],
        items: [cartItem],
      );

      final result = await _cartService.createCart(cart);
      if (result.isSuccess) {
        await startListeningToCart(cartId);
        _navigationService.navigateTo(const CartView());
      } else {
        _logger.e(result.error);
      }
    } else {
      final result = await _cartService.addItemToCart(_cart!.id, cartItem);
      if (result.isSuccess) {
        // _cart!.items.add(cartItem);
        _navigationService.navigateTo(const CartView());
      } else {
        _logger.e(result.error);
      }
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

  void updateItemQuantity(String itemId, int quantity) {
    CartItem cartItem = _cart!.items.firstWhere((item) =>
        item.menuItem.id == itemId && item.userId == _userProvider.user!.id);

    CartItem updatedItem = CartItem(
      menuItem: cartItem.menuItem,
      userId: cartItem.userId,
      quantity: quantity,
      notes: cartItem.notes,
    );

    _cartService.updateItemQuantityInCart(_cart!.id, updatedItem);
  }

  void updateItemNotes(String itemId, String notes) {
    CartItem cartItem = _cart!.items.firstWhere((item) =>
        item.menuItem.id == itemId && item.userId == _userProvider.user!.id);

    CartItem updatedItem = CartItem(
      menuItem: cartItem.menuItem,
      userId: cartItem.userId,
      quantity: cartItem.quantity,
      notes: notes,
    );

    _cartService.updateItemNoteInCart(_cart!.id, updatedItem);
  }
}
