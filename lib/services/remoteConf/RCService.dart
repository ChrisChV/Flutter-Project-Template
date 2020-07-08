import 'package:flutter_project_template/utils/constants/enums/AppEnums.dart';
import 'package:flutter_project_template/services/remoteConf/RC_mobile.dart'
  if(dart.library.html) 'package:flutter_project_template/services/remoteConf/RC_web.dart';


class RCService{

  static Future<void> initRemoteConf() async{
    return RCServicePlatform.initRemoteConf();
  }

  static dynamic get(String keyName, RCType rcType){
    return RCServicePlatform.get(keyName, rcType);
  }


}