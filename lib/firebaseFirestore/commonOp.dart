import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseCommonOperations{
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<String> uploadFile(PickedFile file, name, type) async {
    type = type + name;

    print("TYPE: $type");
    UploadTask uploadTask;

    /// Create a Reference to the file
    Reference ref =
    FirebaseStorage.instance.ref().child('images').child('/$type');

    final metadata = SettableMetadata(
        contentType: 'image/jpg',
        customMetadata: {'picked-file-path': file.path});

    if (kIsWeb) {
      uploadTask = ref.putData(await file.readAsBytes(), metadata);
    } else {
      uploadTask = ref.putFile(File(file.path), metadata);
    }
    Future<String> link = uploadTask.then((res) async {
      var dlink = await res.ref.getDownloadURL();
      print("DOWNOADABLE LINK $type: $dlink");
      return dlink;
    });
    return link;
  }
}