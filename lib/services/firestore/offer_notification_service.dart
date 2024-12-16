import 'package:biteflow/models/offer_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:biteflow/core/constants/firestore_collections.dart';
import 'package:biteflow/core/utils/result.dart';

class OfferNotificationService {
  final CollectionReference _offerNotification = FirebaseFirestore.instance
      .collection(FirestoreCollections.offerNotificationCollection);


  String generateofferNotificationId() {
    return _offerNotification.doc().id;
  }

  // get menuItems of a specific restaurant
  Future<Result<List<OfferNotification>>> getAllOfferNotifications() async {
    try {
      QuerySnapshot querySnapshot = await _offerNotification.get();
      List<OfferNotification> offers = querySnapshot.docs.map((doc) {
        return OfferNotification.fromData(doc.data() as Map<String, dynamic>);
      }).toList();
      return Result(data: offers);
    } catch (e) {
      return Result(error: e.toString());
    }
  }

  // create a new menuItem
  Future<Result<bool>> createOfferNotification(OfferNotification offerNotification) async {
    try {
      await _offerNotification.doc(offerNotification.id).set(offerNotification.toJson());
      return Result(data: true);
    } catch (e) {
      return Result(error: e.toString());
    }
  }
}
