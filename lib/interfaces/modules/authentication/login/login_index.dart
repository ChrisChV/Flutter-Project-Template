import 'package:flutter/material.dart';
import 'package:flutter_project_template/utils/constants/enums/UserEnums.dart';
import 'package:flutter_project_template/view_models/controllers/AppUserController.dart';
import 'package:get/get.dart';
import 'package:paulonia_cache_image/paulonia_cache_image.dart';

class Login extends StatefulWidget{

  State<StatefulWidget> createState(){
    return _LoginState();
  }

}

class _LoginState extends State<Login>{

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GetBuilder<AppUserController>(
            builder: (controller){
              if(controller.isLoggedIn()){
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(image: PCacheImage(controller.appUser.gsUrl)),
                    Text(controller.appUser.name),
                  ],
                );
              }
              else return Text('Not logged in');
            }
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GetBuilder<AppUserController>(
              builder: (controller){
                return MaterialButton(
                  child: controller.isLoggedIn() ?
                  Text('SingOut') :
                  Text('SingIn with Google'),
                  onPressed: (){
                    if(controller.isLoggedIn()) controller.signOut();
                    else{
                      controller.googleSignIn().then((LoginState state){
                        //TODO
                        print(state);
                      });
                    }
                  },
                );
              },
            ),
          ),
          GetBuilder<AppUserController>(
            builder: (controller){
              return Visibility(
                visible: !controller.isLoggedIn(),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                      ),
                    ),
                    TextField(
                      controller: _passController,
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: 'Password'
                      ),
                    ),
                    MaterialButton(
                      onPressed: (){
                        controller.emailPasswordSignIn(
                          _emailController.text,
                          _passController.text,
                        ).then((LoginState state){
                          // TODO
                          print(state);
                        });
                      },
                      child: Text('Sing In'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}