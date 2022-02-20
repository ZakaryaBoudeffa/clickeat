import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseOpSupport {
  //String collectionName = 'restos';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  supportRequired(message, cusId) {
    firestore
        .collection('support')
        .doc()
        .set({
          'message': message,
          'userId': cusId,
          'userType': 'client',
          'dateCreated': DateTime.now()
        })
        .then((value) => print("Message sent to support"))
        .onError(
            (error, stackTrace) => print("ERROR sending message to support!"));
  }
}
