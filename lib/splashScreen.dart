import 'package:flutter_project_template/view_models/notifiers/implementations/ThemeNotifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_project_template/pages/Pricipal.dart';

import 'view_models/notifiers/implementations/AppUserNotifier.dart';

class SplashScreen extends StatefulWidget {
  Widget child;
  double screenWidth = null;
  double screenHeight = null;
  SplashScreen({
    Key key,
    this.screenHeight,
    this.screenWidth,
  }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  ThemeNotifier _themeChanger;
  AppUserNotifier _appUserNotifier;
  double screenWidth;
  double screenHeight;

  // This boolean is to make sure [startSettings] is called only once
  bool settingsLoading;
  
  
  @override
  void initState() {
    super.initState();
    settingsLoading = false;

    // This function calls [startSetting] when [build] finish
    WidgetsBinding.instance.addPostFrameCallback((_){
      startSettings();
    });

  }

  @override
  Widget build(BuildContext context) {
    if(_themeChanger == null) _themeChanger = Provider.of<ThemeNotifier>(context, listen: false);
    if(_appUserNotifier == null) _appUserNotifier = Provider.of<AppUserNotifier>(context, listen: false);
    return initScreen(context);
  }

  /// Initial settings and configurations should be called here
  void startSettings() async{
    if(settingsLoading) return;
    settingsLoading = true;

    // Here theme settings are initialized
    startThemeSettings();

    // Here the user session is initialized
    await _appUserNotifier.initialVerification();

    // Here gets the initial data
    route();

  }

  /// Dimensions of screen are updated in [ThemeNotifier]
  ///
  /// As this must be call after [build] method, it is being called
  /// before the new [Route] is pushed
  void startThemeSettings() {
    if (widget.screenWidth != null)
      _themeChanger.setWidth(widget.screenWidth);
    else
      _themeChanger.setWidth(screenWidth);
    if (widget.screenHeight != null)
      _themeChanger.setHeight(widget.screenHeight);
    else
      _themeChanger.setHeight(screenHeight);
  }

  // * Here you can define where to route after the splashScreen
  void route() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => TabbedAppBarSample()
        )
    );
  }

  Widget initScreen(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext layoutContext, BoxConstraints layoutConstraints) {
        screenWidth = layoutConstraints.maxWidth;
        screenHeight = layoutConstraints.maxHeight;
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  // child: Image.asset("images/logo.png"),
                  child: Icon(Icons.ac_unit),
                ),
                Padding(padding: EdgeInsets.only(top: 20.0)),
                Text(
                  "Splash Screen",
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                Padding(padding: EdgeInsets.only(top: 20.0)),
                CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  strokeWidth: 1,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
