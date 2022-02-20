import 'package:clicandeats/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAssociationOp {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getAllAssociations() {
    return firestore.collection('associations').snapshots();
  }

  Future<DocumentSnapshot> getMyAssociations(uid) {
    return firestore.collection('client').doc(uid).get();
  }

  Stream<DocumentSnapshot> getMyAssociationsStream(uid) {
    return firestore.collection('client').doc(uid).snapshots();
  }

  Future updateMyDonationAmount(double amount, uid){
    return firestore.collection('client').doc(uid).update({
      'donatedAmount': FieldValue.increment(amount)
    });
  }

  getAssociationDetails(aId){
    return firestore.collection('associations').doc(aId).get();
  }

  addAssociations(cId, List<String> aId) async {
   await firestore.collection('client').doc(cId).update({
    'associations': []
    });

    firestore.collection('client').doc(cId).update({
      'associations': FieldValue.arrayUnion(aId)
    });
  }
}
