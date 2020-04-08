import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_template/services/remoteConf/KeyNames.dart';
import 'package:flutter_project_template/services/remoteConf/RCService.dart';
import 'package:flutter_project_template/utils/constants/TypesConstants.dart';
import 'package:url_launcher/url_launcher.dart';

class Contact extends StatelessWidget{

  @override
  Widget build(BuildContext context){
   return Center(
     child: Column(
       mainAxisAlignment: MainAxisAlignment.center,
       children: <Widget>[
         MaterialButton(
           child: Text('Contact page'),
           onPressed: (){
              launch(RCService.get(KeyNames.CONTACT_URL, RCType.STRING));
           },
         )
       ],
     ),
   );
  }
}