import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter/cupertino.dart';
import 'package:tuple/tuple.dart';

class TestUtils{

  static Tuple2<dynamic, dynamic> initialTestConfiguration(){
    WidgetsFlutterBinding.ensureInitialized();
    var firestoreInstance = MockFirestoreInstance();
    var storageInstance = MockFirebaseStorage();
    return Tuple2<dynamic, dynamic>(firestoreInstance, storageInstance);
  }

}