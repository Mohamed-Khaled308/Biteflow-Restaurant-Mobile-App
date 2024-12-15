import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:biteflow/core/constants/firestore_collections.dart';
import 'package:biteflow/core/utils/result.dart';
import 'package:biteflow/models/order.dart'
    as biteflow; // for ambiguity reasons

class OrderService {
  final CollectionReference _orders = FirebaseFirestore.instance
      .collection(FirestoreCollections.ordersCollection);

  String generateOrderId() {
    return _orders.doc().id;
  }

  // get orders of a specific restaurant
  Future<Result<List<biteflow.Order>>> getOrders(String restaurantId) async {
    try {
      QuerySnapshot ordersSnapshot =
          await _orders.where('restaurantId', isEqualTo: restaurantId).get();
      return Result(
          data: ordersSnapshot.docs
              .map((doc) =>
                  biteflow.Order.fromData(doc.data() as Map<String, dynamic>))
              .toList());
    } catch (e) {
      return Result(error: e.toString());
    }
  }

  Future<Result<List<biteflow.Order>>> getOrdersByClient(
      String clientId) async {
    try {
      QuerySnapshot ordersSnapshot = await _orders.get();

      List<biteflow.Order> filteredOrders = ordersSnapshot.docs
          .map((doc) =>
              biteflow.Order.fromData(doc.data() as Map<String, dynamic>))
          .where((order) => order.orderClientsPayment
              .any((payment) => payment.userId == clientId))
          .toList();

      return Result(data: filteredOrders);
    } catch (e) {
      return Result(error: e.toString());
    }
  }

  Future<Result<String>> placeOrder(biteflow.Order order) async {
    try {
      final String orderId = generateOrderId();
      await _orders.doc(orderId).set(order.toJson());
      return Result(data: orderId);
    } catch (e) {
      return Result(error: e.toString());
    }
  }

  // update order status
  Future<Result<bool>> updateOrderStatus(String orderId, String status) async {
    try {
      await _orders.doc(orderId).update({'status': status});
      return Result(data: true);
    } catch (e) {
      return Result(error: e.toString());
    }
  }
}
