import 'package:flutter_project_template/interfaces/general_screens/splash_screen/splash_index.dart';
import 'package:flutter_project_template/interfaces/modules/principal/principal_index.dart';
import 'package:flutter_project_template/routes/bindings.dart';
import 'package:flutter_project_template/routes/routingConstants.dart';
import 'package:get/get.dart';

class UIRouter{

  static final List<GetPage> listPages = [
    GetPage(
      name: RouteNames.SplashRoute,
      page: () => SplashScreenIndex(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: RouteNames.PrincipalRoute,
      page: () => TabbedAppBarSample(),
    ),
  ];

}