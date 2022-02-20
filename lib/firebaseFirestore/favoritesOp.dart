import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFavoriteOp{
  String collectionName = 'client';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  addDishToFavorites(cid, resId, mid){
     firestore.collection(collectionName).doc(cid).update({
      'favDishes': FieldValue.arrayUnion([resId+":"+mid])
    });
  }

  addResToFavorites(cid, resId){
    print("resid: $resId");
    firestore.collection(collectionName).doc(cid).update({
      'favRestos': FieldValue.arrayUnion([resId])
    });
  }

  Stream<DocumentSnapshot> getFavoriteDishes(cid){
    return firestore.collection(collectionName).doc(cid).snapshots();
  }

  Future<DocumentSnapshot> getFavStatus(cid, resId){
    return firestore.collection(collectionName).doc(cid).get();
  }

  Future<DocumentSnapshot> getFavDishStatus(cid){
    return firestore.collection(collectionName).doc(cid).get();
  }

  Stream<DocumentSnapshot> getFavoriteRestos(cid){
    return firestore.collection(collectionName).doc(cid).snapshots();
  }

  removeDishFromFavorites(cid, resId, mid){
    firestore.collection(collectionName).doc(cid).update({
      'favDishes': FieldValue.arrayRemove([resId+":"+mid])
    });
  }

  removeResFromFavorites(cid, resId){
    firestore.collection(collectionName).doc(cid).update({
      'favRestos': FieldValue.arrayRemove([resId])
    });
  }
}