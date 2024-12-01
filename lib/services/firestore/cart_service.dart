import 'package:biteflow/models/cart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:biteflow/core/constants/firestore_collections.dart';
import 'package:biteflow/core/utils/result.dart';

class CartService {
  final CollectionReference _carts = FirebaseFirestore.instance
      .collection(FirestoreCollections.cartsCollection);

  String generateCartId() {
    return _carts.doc().id;
  }

  Future<Result<bool>> createCart(Cart cart) async {
    try {
      await _carts.doc(cart.id).set(cart.toJson());
      return Result(data: true);
    } catch (e) {
      return Result(error: e.toString());
    }
  }

  Future<Result<Cart>> getCartById(String cartId) async {
    try {
      DocumentSnapshot cartDoc = await _carts.doc(cartId).get();
      if (cartDoc.exists) {
        Map<String, dynamic> cartData = cartDoc.data() as Map<String, dynamic>;
        return Result(data: Cart.fromData(cartData));
      }
      return Result(error: 'Cart $cartId not found');
    } catch (e) {
      return Result(error: e.toString());
    }
  }

  Future<Result<bool>> updateCart(Cart cart) async {
    try {
      await _carts.doc(cart.id).update(cart.toJson());
      return Result(data: true);
    } catch (e) {
      return Result(error: e.toString());
    }
  }

  Future<Result<bool>> deleteCart(String cartId) async {
    try {
      await _carts.doc(cartId).delete();
      return Result(data: true);
    } catch (e) {
      return Result(error: e.toString());
    }
  }

  Stream<Cart> listenToCartUpdates(String cartId) {
    return _carts.doc(cartId).snapshots().map((snapshot) {
      if (!snapshot.exists) {
        throw Exception('Cart not found.');
      }
      Map<String, dynamic> cartData = snapshot.data() as Map<String, dynamic>;
      return Cart.fromData(cartData);
    }).handleError((error) {
      throw Exception('Error listening to cart updates: $error');
    });
  }

  Future<Result<bool>> addItemToCart(String cartId, CartItem item) async {
    try {
      await _carts.doc(cartId).update({
        'items': FieldValue.arrayUnion([item.toJson()])
      });
      return Result(data: true);
    } catch (e) {
      return Result(error: 'Error adding item: $e');
    }
  }

  Future<Result<bool>> addParticipantToCart(
      String cartId, CartParticipant participant) async {
    try {
      await _carts.doc(cartId).update({
        'participants': FieldValue.arrayUnion([participant.toJson()])
      });
      return Result(data: true);
    } catch (e) {
      return Result(error: 'Error adding participant: $e');
    }
  }

  Future<Result<bool>> removeParticipantFromCart(
      String cartId, CartParticipant participant) async {
    try {
      await _carts.doc(cartId).update({
        'participants': FieldValue.arrayRemove([participant.toJson()])
      });
      return Result(data: true);
    } catch (e) {
      return Result(error: 'Error removing participant: $e');
    }
  }

  Future<Result<bool>> removeItemFromCart(String cartId, CartItem item) async {
    try {
      await _carts.doc(cartId).update({
        'items': FieldValue.arrayRemove([item.toJson()])
      });
      return Result(data: true);
    } catch (e) {
      return Result(error: 'Error removing item: $e');
    }
  }

  Future<Result<bool>> updateItemQuantityInCart(
      String cartId, CartItem item) async {
    try {
      DocumentSnapshot snapshot = await _carts.doc(cartId).get();
      if (!snapshot.exists) {
        throw Exception('Cart not found');
      }

      Map<String, dynamic> cartData = snapshot.data() as Map<String, dynamic>;
      List<CartItem> items = (cartData['items'] as List)
          .map((itemData) => CartItem.fromData(itemData))
          .toList();

      CartItem existingItem = items.firstWhere(
        (cartItem) =>
            cartItem.userId == item.userId &&
            cartItem.menuItem.id == item.menuItem.id,
        orElse: () => throw Exception('Item not found for this user'),
      );

      existingItem.quantity = item.quantity;

      await _carts.doc(cartId).update({
        'items': items.map((e) => e.toJson()).toList(),
      });

      return Result(data: true);
    } catch (e) {
      return Result(error: 'Error updating item quantity: $e');
    }
  }

  Future<Result<bool>> updateItemNoteInCart(
      String cartId, CartItem item) async {
    try {
      DocumentSnapshot snapshot = await _carts.doc(cartId).get();
      if (!snapshot.exists) {
        throw Exception('Cart not found');
      }

      Map<String, dynamic> cartData = snapshot.data() as Map<String, dynamic>;
      List<CartItem> items = (cartData['items'] as List)
          .map((itemData) => CartItem.fromData(itemData))
          .toList();

      CartItem existingItem = items.firstWhere(
        (cartItem) =>
            cartItem.userId == item.userId &&
            cartItem.menuItem.id == item.menuItem.id,
        orElse: () => throw Exception('Item not found for this user'),
      );

      existingItem.notes = item.notes;

      await _carts.doc(cartId).update({
        'items': items.map((e) => e.toJson()).toList(),
      });

      return Result(data: true);
    } catch (e) {
      return Result(error: 'Error updating item note: $e');
    }
  }
}
