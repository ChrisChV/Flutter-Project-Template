import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_project_template/utils/constants/SizesConstants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class Utils{

  static Future<bool> checkNetwork() async{
    return (await Connectivity().checkConnectivity())
        != ConnectivityResult.none;
  }

  static String getGmailProfileUrl(String photoUrl, bool big){
    String res = "";
    for(int c in photoUrl.runes){
      var char = String.fromCharCode(c);
      res += char;
      if(char == '='){
        if(big){
          res += 'h' + SizesConstants.PROFILE_IMAGE_BIG_HEIGHT.toString();
          res += '-w' + SizesConstants.PROFILE_IMAGE_BIG_WIDTH.toString();
        }
        else{
          res += 'h' + SizesConstants.PROFILE_IMAGE_HEIGHT.toString();
          res += '-w' + SizesConstants.PROFILE_IMAGE_WIDTH.toString();
        }
        break;
      }
    }
    return res;
  }

  static String getFacebookProfileUrl(String photoUrl, bool big){
    String res;
    if(big){
      res = photoUrl + '?height=' + SizesConstants.PROFILE_IMAGE_BIG_HEIGHT.toString();
      res += '&width=' + SizesConstants.PROFILE_IMAGE_BIG_WIDTH.toString();
    }
    else{
      res = photoUrl + '?height=' + SizesConstants.PROFILE_IMAGE_HEIGHT.toString();
      res += '&width=' + SizesConstants.PROFILE_IMAGE_WIDTH.toString();
    }
    return res;
  }

  static Future<File> getImageFromUrl(String tempName, String url) async{
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File resFile = File(tempPath + tempName + '.jpg');
    final response = await http.get(url);
    await resFile.writeAsBytes(response.bodyBytes);
    return resFile;
  }

  static bool isOnRelease(){
    return kReleaseMode;
  }

  static bool isOnTest(){
    return Platform.environment.containsKey('FLUTTER_TEST');
  }

}