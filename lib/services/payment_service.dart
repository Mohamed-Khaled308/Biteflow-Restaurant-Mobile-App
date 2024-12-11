import 'package:biteflow/core/utils/result.dart';
import 'package:dio/dio.dart';
import 'package:biteflow/core/constants/api_constants.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:biteflow/locator.dart';





class PaymentService {

  final Logger _logger = getIt<Logger>();

  
  // in case of deployment, should be migrated to server side (firestore)
  Future<Result<String>> createPaymentIntent(int amountInCents) async {
    try{

      final Dio dio = Dio();
      Map<String, dynamic> data = {
        'amount': amountInCents,
        'currency': 'usd',
        'payment_method_types[]': 'card',
      };

      final Response response = await dio.post(
        APIConstants.stripeCreatePaymentIntentUrl,
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET_KEY']!}',
            'Content-Type': 'application/x-www-form-urlencoded'
          }
      ));

      if(response.data != null){
        return Result(data: response.data['client_secret']);
      }
      return Result(error: 'Error creating payment intent');
    }
    catch(e){
      _logger.e(e.toString());
      return Result(error: e.toString());
    }
    
  }

  


}
