
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class Utils{

  static Future<File> getImageFromUrl(String tempName, String url) async{
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File resFile = File(tempPath + tempName + '.jpg');
    final response = await http.get(url);
    await resFile.writeAsBytes(response.bodyBytes);
    return resFile;
  }


}