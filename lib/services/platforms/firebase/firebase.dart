import 'package:flutter_project_template/utils/constants/enums/AppEnums.dart';
import 'package:flutter_project_template/services/platforms/firebase/firebase_mobile.dart'
  if(dart.library.html) 'package:flutter_project_template/services/platforms/firebase/firebase_web.dart';

class FirebaseService{

  static dynamic getStorageReference(List<String> path){
    return FirebaseServicePlatform.getStorageReference(path);
  }

  static Future<void> putFile(
    dynamic storageReference,
    dynamic file,
    StorageFileType type
  ){
    return FirebaseServicePlatform.putFile(storageReference, file, type);
  }

}