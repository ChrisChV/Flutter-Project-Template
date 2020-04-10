import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_project_template/services/remoteConf/KeyNames.dart';
import 'package:flutter_project_template/services/remoteConf/default_values.dart';
import 'package:flutter_project_template/utils/constants/TimeConstants.dart';
import 'package:flutter_project_template/utils/constants/enums/AppEnums.dart';
import 'package:flutter_project_template/utils/utils.dart';

class RCService{

  static RemoteConfig _remoteConfig;

  static Future<void> initRemoteConf() async{
    _remoteConfig = await RemoteConfig.instance;
    await _remoteConfig.setDefaults(RCDefault.defaults);
    if(Utils.isOnRelease() && (await Utils.checkNetwork())){
      await _remoteConfig.fetch(
          expiration: const Duration(hours: TimeConstants.REMOTE_CONF_EXPIRATION_TIME_HOUR)
      );
    }
    await _remoteConfig.activateFetched();
  }

  static dynamic get(String keyName, RCType rcType){
    if(Utils.isOnTest()) return RCDefault.defaults[KeyNames];
    switch(rcType){
      case RCType.STRING:
        return _remoteConfig.getString(keyName);
      case RCType.INT:
        return _remoteConfig.getInt(keyName);
      case RCType.DOUBLE:
        return _remoteConfig.getDouble(keyName);
      case RCType.BOOL:
        return _remoteConfig.getBool(keyName);
      default:
        return _remoteConfig.getValue(keyName);
    }
  }
}