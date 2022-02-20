import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseNotificationsOp{
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  addNotificationForRestaurant(title, resId) async {
    try {
      /// Save notification data to firestore db
      await firestore
          .collection('restos')
          .doc(resId)
          .collection('notifications')
          .doc()
          .set({'title': title, 'timestamp': DateTime.now(), 'read': false})
          .whenComplete(() => print('Notification added'))
          .catchError((error) {
        print('Fire-store error ${error.toString()}');
      });
    } catch (e) {
      print(e);
    }
  }

  addNotificationForDeliveryBoyForTip(title, carrierId) async {
    try {
      /// Save notification data to firestore db
      await firestore
          .collection('carriers')
          .doc(carrierId)
          .collection('notifications')
          .doc()
          .set({'title': title, 'timestamp': DateTime.now(), 'read': false})
          .whenComplete(() => print('Notification added'))
          .catchError((error) {
        print('Fire-store error ${error.toString()}');
      });
    } catch (e) {
      print(e);
    }
  }
}