import 'package:biteflow/locator.dart';
import 'package:biteflow/models/promotional_offer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:biteflow/core/utils/result.dart';
import 'package:logger/logger.dart';

class PromotionalOfferService {
  final CollectionReference _offers =
      FirebaseFirestore.instance.collection('promotionalOffers');
  final Logger _logger = getIt<Logger>();

  String generateId() {
    return _offers.doc().id;
  }

  // Stream<List<PromotionalOffer>> subscribeToOffers() {
  //   return _offers
  //       .where('isActive', isEqualTo: true)
  //       .where('endDate', isGreaterThan: Timestamp.fromDate(DateTime.now()))
  //       .snapshots()
  //       .map((snapshot) {
  //     return snapshot.docs
  //         .map((doc) =>
  //             PromotionalOffer.fromData(doc.data() as Map<String, dynamic>))
  //         .toList();
  //   });
  // }

  // Stream<List<PromotionalOffer>> subscribeToRestaurantOffers(
  //     String restaurantId) {
  //   return _offers
  //       .where('restaurantId', isEqualTo: restaurantId)
  //       .where('isActive', isEqualTo: true)
  //       .snapshots()
  //       .map((snapshot) {
  //     return snapshot.docs
  //         .map((doc) =>
  //             PromotionalOffer.fromData(doc.data() as Map<String, dynamic>))
  //         .toList();
  //   });
  // }

  Future<Result<bool>> createOffer(PromotionalOffer offer) async {
    try {
      await _offers.doc(offer.id).set(offer.toJson());
      return Result(data: true);
    } catch (e) {
      _logger.e(e.toString());
      return Result(error: e.toString());
    }
  }

 

  Future<Result<List<PromotionalOffer>>> getAllActiveOffers() async {
    try {
      QuerySnapshot querySnapshot = await _offers
          .where('isActive', isEqualTo: true)
          .where('endDate', isGreaterThanOrEqualTo: DateTime.now().toIso8601String().split('T')[0])
          .get();

      List<PromotionalOffer> offers = querySnapshot.docs.map((doc) {
        return PromotionalOffer.fromData(doc.data() as Map<String, dynamic>);
      }).toList();

      return Result(data: offers);
    } catch (e) {
      _logger.e(e.toString());
      return Result(error: e.toString());
    }
  }


  //get the promotional offers for the restaurantID
  Future<Result<List<PromotionalOffer>>> getRestaurantOffers(String restaurantId) async {
    try {
      QuerySnapshot querySnapshot = await _offers
          .where('restaurantId', isEqualTo: restaurantId)
          .where('isActive', isEqualTo: true)
          .get();

      List<PromotionalOffer> offers = querySnapshot.docs.map((doc) {
        return PromotionalOffer.fromData(doc.data() as Map<String, dynamic>);
      }).toList();

      return Result(data: offers);
    } catch (e) {
      _logger.e(e.toString());
      return Result(error: e.toString());
    }
  }
}
