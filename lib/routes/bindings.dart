import 'package:flutter_project_template/interfaces/general_screens/splash_screen/controllers/splash_ui_controller.dart';
import 'package:get/get.dart';

class SplashBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<SplashScreenController>(() => SplashScreenController());
  }
}