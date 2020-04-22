import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_template/notifiers/implementations/AppUserNotifier.dart';
import 'package:flutter_project_template/utils/constants/enums/UserEnums.dart';
import 'package:provider/provider.dart';

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
                else{
                  appUserNotifier.googleSignIn().then((LoginState state){
                    //TODO
                    print(state);
                  });
                }
              },
            ),
          ),
          Visibility(
            visible: !appUserNotifier.isLoggedIn(),
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
                    appUserNotifier.emailPasswordSignIn(
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
          )
        ],
      ),
    );
  }
}