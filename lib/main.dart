import 'package:catcher/catcher.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_template/routes/router.dart';
import 'package:flutter_project_template/routes/routingConstants.dart';
import 'package:flutter_project_template/services/FCMService.dart';
import 'package:flutter_project_template/services/remoteConf/default_values.dart';
import 'package:flutter_project_template/utils/constants/TimeConstants.dart';
import 'package:flutter_project_template/utils/theme.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_project_template/view_models/controllers/AppUserController.dart';
import 'package:get/get.dart';
import 'package:paulonia_error_service/paulonia_error_service.dart';
import 'package:paulonia_remote_conf/paulonia_remote_conf.dart';
import 'package:paulonia_cache_image/paulonia_cache_image.dart';
import 'package:paulonia_utils/paulonia_utils.dart';

void main() async{

  // * if true then it use [devicePreview] and you'll have
  // * to specify the device dimensions manually
  final bool preview = false;
  // * if [preview] is set to true these dimensions
  // * are used for the [ThemeNotifier]
  double deviceWidth = 800;
  double deviceHeight = 1280;

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await PauloniaRemoteConf.init(
      RCDefault.defaults,
      expirationTimeInHours: TimeConstants.REMOTE_CONF_EXPIRATION_TIME_HOUR,
  );

  await PCacheImage.init(proxy: "https://cors-anywhere.herokuapp.com/");

  if(PUtils.isOnWeb()){

  }
  else{
    FCMService.initFCM();
  }

  Map<String, CatcherOptions> catcherConf = PauloniaErrorService.getCatcherConfig();

  Catcher(
      rootWidget: DevicePreview(
        enabled: preview,
        builder: (context) => MaterialAppWithTheme(
          screenHeight: deviceHeight,
          screenWidth: deviceWidth,
        ),
      ),
      debugConfig: catcherConf['debug'],
      releaseConfig: catcherConf['release'],
      profileConfig: catcherConf['profile']
  );

}

/// This widget is needed to implement the dynamic theme
///
/// you can freely change the return in [build] function
class MaterialAppWithTheme extends StatefulWidget {
  double screenWidth;
  double screenHeight;

  MaterialAppWithTheme({
    Key key,
    this.screenHeight,
    this.screenWidth,
  }) : super(key: key);

  @override
  _MaterialAppWithThemeState createState() => _MaterialAppWithThemeState();
}

class _MaterialAppWithThemeState extends State<MaterialAppWithTheme> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      showPerformanceOverlay: false,
      debugShowCheckedModeBanner: false,
      onInit: loadInitialControllers,
      title: 'Flutter project template',
      locale: DevicePreview.of(context).locale,
      builder: DevicePreview.appBuilder,
      getPages: UIRouter.listPages,
      initialRoute: RouteNames.SplashRoute,
      theme: CustomTheme.themeData
    );
  }
}

loadInitialControllers() {
  Get.put(AppUserController(), permanent: true);
}
