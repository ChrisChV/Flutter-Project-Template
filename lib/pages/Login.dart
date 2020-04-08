import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_template/notifiers/implementations/AppUserNotifier.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget{

  State<StatefulWidget> createState(){
    return _LoginState();
  }

}

class _LoginState extends State<Login>{

  @override
  Widget build(BuildContext context){
    final AppUserNotifier appUserNotifier = Provider.of<AppUserNotifier>(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          appUserNotifier.isLoggedIn() ?
              Text(appUserNotifier.appUser.name) :
              Text('Not logged in'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MaterialButton(
              child: appUserNotifier.isLoggedIn() ?
                      Text('SingOut') :
                      Text('SingIn with Google'),
              onPressed: (){
                if(appUserNotifier.isLoggedIn()) appUserNotifier.signOut();
                else appUserNotifier.googleSignIn();
              },
            ),
          )
        ],
      ),
    );
  }
}