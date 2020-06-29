import 'dart:io';

import 'package:flutter_project_template/utils/constants/enums/AppEnums.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseServicePlatform{

  static dynamic getStorageReference(List<String> path){
    var res = FirebaseStorage.instance.ref();
    for(String element in path){
      res = res.child(element);
    }
    return res;
  }

  static Future<void> putFile(
    dynamic storageReference,
    dynamic file,
    StorageFileType type
  ) async{
    StorageMetadata metadata;
    switch(type){
      case StorageFileType.IMAGE_PNG:
        metadata = StorageMetadata(contentType: 'image/png');
        break;
      case StorageFileType.IMAGE_JPG:
        metadata = StorageMetadata(contentType: 'image/jpg');
        break;
    }
    File _file = File(file.path);
    StorageUploadTask task = storageReference.putFile(_file, metadata);
    await task.onComplete;
  }


}