import 'package:biteflow/core/providers/user_provider.dart';
import 'package:biteflow/locator.dart';
import 'package:biteflow/models/client.dart';
import 'package:biteflow/models/order.dart';
import 'package:biteflow/services/firestore/order_service.dart';
import 'package:biteflow/viewmodels/base_model.dart';
import 'package:logger/logger.dart';

class ClientOrdersViewModel extends BaseModel {
  final Logger _logger = getIt<Logger>();
  final Client _clientLogged = getIt<UserProvider>().user as Client;
  List<Order>? _orders;
  List<Order>? get orders => _orders;
  Client get clientLogged => _clientLogged;



  Future<void> _fetchClientOrders() async {
    final ordersData = await getIt<OrderService>()
        .getOrdersByClient(_clientLogged.id);
    if(ordersData.isSuccess){
      _orders = ordersData.data;
    } else {
      _logger.e(ordersData.error);
    }
  }

  Future<void> loadClientOrdersData() async {
    setBusy(true);

    await _fetchClientOrders();

    setBusy(false);
  }
  

}
