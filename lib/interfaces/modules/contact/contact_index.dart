import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_template/services/remoteConf/KeyNames.dart';
import 'package:flutter_project_template/view_models/controllers/ArticleController.dart';
import 'package:flutter_project_template/view_models/controllers/OtherArticleController.dart';
import 'package:get/get.dart';
import 'package:paulonia_remote_conf/constants.dart';
import 'package:paulonia_remote_conf/paulonia_remote_conf.dart';
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
            onPressed: () async{
              launch(PauloniaRemoteConf.get(KeyNames.CONTACT_URL, PRCType.STRING));
            },
          ),
          MaterialButton(
            child: Text('Load first articles'),
            onPressed: () async{
              //launch(PauloniaRemoteConf.get(KeyNames.CONTACT_URL, PRCType.STRING));
              print(await Get.find<ArticleController>().loadFirstArticles());

              for(var tt in Get.find<ArticleController>().articles){
                print(tt.content);
              }
            },
          ),
          MaterialButton(
            child: Text('Load next articles'),
            onPressed: () async{

              print(await Get.find<ArticleController>().loadNextArticles());

              for(var tt in Get.find<ArticleController>().articles){
                print(tt.content);
              }
            },
          ),
          MaterialButton(
            child: Text('Print first controller'),
            onPressed: (){
              Get.find<ArticleController>().printAll();
            },
          ),
          MaterialButton(
            child: Text('Print second controller'),
            onPressed: (){
              Get.find<OtherArticleController>().printAll();
            },
          )
        ],
      ),
    );
  }
}