import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_template/services/remoteConf/KeyNames.dart';
import 'package:paulonia_remote_conf/constants.dart';
import 'package:paulonia_remote_conf/paulonia_remote_conf.dart';
import 'package:url_launcher/url_launcher.dart';

class Contact extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    print("AAAAAAAAA");
    print(PauloniaRemoteConf.get(KeyNames.CONTACT_URL, PRCType.STRING));
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          MaterialButton(
            child: Text('Contact page'),
            onPressed: (){
              launch(PauloniaRemoteConf.get(KeyNames.CONTACT_URL, PRCType.STRING));
            },
          )
        ],
      ),
    );
  }
}