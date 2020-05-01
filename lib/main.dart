import 'package:catcher/catcher_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_template/services/ErrorService.dart';
import 'package:flutter_project_template/services/FCMService.dart';
import 'package:flutter_project_template/services/remoteConf/RCService.dart';
import 'package:flutter_project_template/splashScreen.dart';
import 'package:flutter_project_template/view_models/notifiers/implementations/AppUserNotifier.dart';
import 'package:flutter_project_template/view_models/notifiers/implementations/ThemeNotifier.dart';
import 'package:device_preview/device_preview.dart';
import 'package:provider/provider.dart';

void main() async{

  // * if true then it use [devicePreview] and you'll have
  // * to specify the device dimensions manually
  final bool preview = false;
  // * if [preview] is set to true these dimensions
  // * are used for the [ThemeNotifier]
  double deviceWidth = 800;
  double deviceHeight = 1280;

  Map<String, CatcherOptions> catcherConf = ErrorService.getCatcherConfig();
  WidgetsFlutterBinding.ensureInitialized();
  FCMService.initFCM();
  await RCService.initRemoteConf();

  // * Here you must initialize the providers of the app
  var providers = [
    ChangeNotifierProvider(create: (_) => AppUserNotifier(),),
    ChangeNotifierProvider(create: (_) => ThemeNotifier(),),
  ];

  if (preview) {
    runApp(DevicePreview(
      builder: (context) => MultiProvider(
        providers: providers,
        child: MaterialAppWithTheme(
          preview: preview,
          screenHeight: deviceHeight,
          screenWidth: deviceWidth,
        ),
      ),
    ));
  }
  else {
    Catcher(
        MultiProvider(
          providers: providers,
          child: MaterialAppWithTheme(
            preview: preview,
            screenHeight: deviceHeight,
            screenWidth: deviceWidth,
          ),
        ),
        debugConfig: catcherConf['debug'],
        releaseConfig: catcherConf['release'],
        profileConfig: catcherConf['profile']
    );
  }

}

/// This widget is needed to implement the dynamic theme
///
/// you can freely change the return in [build] function
class MaterialAppWithTheme extends StatefulWidget {
  bool preview;
  double screenWidth;
  double screenHeight;

  MaterialAppWithTheme({
    Key key,
    this.preview,
    this.screenHeight,
    this.screenWidth,
  }) : super(key: key);

  @override
  _MaterialAppWithThemeState createState() => _MaterialAppWithThemeState();
}

class _MaterialAppWithThemeState extends State<MaterialAppWithTheme> {
  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      theme: themeNotifier.getTheme(),
      home: SplashScreen(
        screenWidth: widget.preview ? widget.screenWidth : null,
        screenHeight: widget.preview ? widget.screenHeight : null,
      ),
    );
  }
}
