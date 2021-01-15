import 'package:flutter/material.dart';
import 'package:flutter_project_template/interfaces/general_screens/splash_screen/controllers/splash_ui_controller.dart';
import 'package:get/get.dart';

class SplashScreenIndex extends StatelessWidget {

  final SplashScreenController controller = Get.find();

  @override
  Widget build(BuildContext context){
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
  }

}