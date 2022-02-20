

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFeeOp{
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot> getFee(){
    return firestore.collection('fee').doc('fee').get();
  }
}