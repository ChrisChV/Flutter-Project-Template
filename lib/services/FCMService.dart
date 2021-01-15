import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_project_template/AppConfiguration.dart';
import 'package:flutter_project_template/repositories/UserRepository.dart';
import 'package:http/http.dart' as http;

class FCMService {

  static final FirebaseMessaging _fcm = FirebaseMessaging();
  static StreamSubscription iosSubscription;

  static String actualReportId;
  static bool openInbox = false;

  static void initFCM(){
    /*
    if (Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
        // save the token  OR subscribe to a topic here
      });

      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage:');
        print(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch:");
        print(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume:");
        print(message);
      },
    );
     */
  }

  static Future<String> getFcmToken() async{
    return await _fcm.getToken();
  }

  static Future<void> sendNotification(
      String destUid,
      String title,
      String body,
      {Map<String, dynamic> extraData} ) async{
    List<String> tokenDevices = await UserRepository.getDevicesTokens(destUid);
    var random = new Random();
    if(tokenDevices.isEmpty) return;
    for(String token in tokenDevices){
      await http.post(
        AppConfiguration.FCM_POST_URL,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=' + AppConfiguration.FCM_API_STRING,
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title,
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': random.nextInt(10000).toString(),
              'status': 'done',
              'extras': extraData,
            },
            'to': token,
          },
        ),
      );
    }
  }
}