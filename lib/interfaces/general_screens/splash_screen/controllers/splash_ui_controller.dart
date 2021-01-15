import 'package:flutter_project_template/routes/routingConstants.dart';
import 'package:flutter_project_template/view_models/controllers/AppUserController.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController {

  @override
  void onReady() {
    loadControllers();
    super.onReady();
  }

  Future<void> loadControllers() async{
    await Get.find<AppUserController>().initialVerification();
    navigate();
  }

  void navigate(){
    Get.offAllNamed(RouteNames.PrincipalRoute);
  }

}