import 'package:flutter_project_template/AppConfiguration.dart';
import 'package:flutter_project_template/utils/constants/enums/AppEnums.dart';
import 'package:firebase/firebase.dart' as fb;

class FirebaseServicePlatform{

  static dynamic getStorageReference(List<String> path){
    var res = fb.storage().refFromURL(AppConfiguration.GS_BUCKET_URL);
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
    fb.UploadMetadata metadata;
    switch(type){
      case StorageFileType.IMAGE_PNG:
        metadata = fb.UploadMetadata(contentType: 'image/png');
        break;
      case StorageFileType.IMAGE_JPG:
        metadata = fb.UploadMetadata(contentType: 'image/jpg');
    }
    fb.UploadTask _uploadTask = storageReference.put(await file.readAsBytes(), metadata);
    await _uploadTask.future.whenComplete(() => null);
  }



}