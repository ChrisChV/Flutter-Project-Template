import 'package:flutter/cupertino.dart';
import 'package:tuple/tuple.dart';

class TestUtils{

  static Tuple2<dynamic, dynamic> initialTestConfiguration(){
    WidgetsFlutterBinding.ensureInitialized();

    /// Broke for firestore updates
    //var firestoreInstance = MockFirestoreInstance();
    //var storageInstance = MockFirebaseStorage();
    //return Tuple2<dynamic, dynamic>(firestoreInstance, storageInstance);
  }

}