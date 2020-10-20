import 'package:flutter_project_template/services/remoteConf/default_values.dart';
import 'package:flutter_project_template/utils/constants/enums/AppEnums.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:paulonia_utils/paulonia_utils.dart';

class RCServicePlatform{

  static final _remoteConfig = fb.remoteConfig();

  static Future<void> initRemoteConf() async{
    await _remoteConfig.ensureInitialized();
    _remoteConfig.defaultConfig = RCDefault.defaults;
    if(PUtils.isOnRelease() && (await PUtils.checkNetwork())){
      await _remoteConfig.fetch();
    }
    await _remoteConfig.activate();
  }

  static dynamic get(String keyName, RCType rcType){
    if(PUtils.isOnTest()) return RCDefault.defaults[keyName];
    switch(rcType){
      case RCType.STRING:
        return _remoteConfig.getString(keyName);
      case RCType.INT:
        return _remoteConfig.getNumber(keyName)?.toInt();
      case RCType.DOUBLE:
        return _remoteConfig.getNumber(keyName)?.toDouble();
      case RCType.BOOL:
        return _remoteConfig.getBoolean(keyName);
      default:
        return _remoteConfig.getValue(keyName);
    }
  }


}