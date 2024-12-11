import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:biteflow/core/constants/firestore_collections.dart';
import 'package:biteflow/core/utils/result.dart';
import 'package:biteflow/models/order.dart' as biteflow; // for ambiguity reasons

class OrderService {
   final CollectionReference _orders = FirebaseFirestore.instance
      .collection(FirestoreCollections.ordersCollection);

  String generateOrderId() {
    return _orders.doc().id;
  }

  // get orders of a specific restaurant
  Future<Result<List<biteflow.Order>>> getOrders(String restaurantId) async {
    try {
      QuerySnapshot ordersSnapshot = await _orders
          .where('restaurantId', isEqualTo: restaurantId)
          .get();
      return Result(
          data: ordersSnapshot.docs
              .map((doc) =>
                  biteflow.Order.fromData(doc.data() as Map<String, dynamic>))
              .toList());
    } catch (e) {
      return Result(error: e.toString());
    }
  }

  // update order status
  Future<Result<bool>> updateOrderStatus(
      String orderId, String status) async {
    try {
      await _orders.doc(orderId).update({'status': status});
      return Result(data: true);
    } catch (e) {
      return Result(error: e.toString());
    }
  }
}