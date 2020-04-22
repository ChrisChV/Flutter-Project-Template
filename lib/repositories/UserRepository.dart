import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_project_template/AppConfiguration.dart';
import 'package:flutter_project_template/models/UserModel.dart';
import 'package:flutter_project_template/services/AuthService.dart';
import 'package:flutter_project_template/services/DocumentService.dart';
import 'package:flutter_project_template/utils/constants/enums/UserEnums.dart';
import 'package:flutter_project_template/utils/constants/storage/StorageConstants.dart';
import 'package:flutter_project_template/utils/constants/firestore/FirestoreConstants.dart';
import 'package:flutter_project_template/utils/constants/firestore/collections/Devices.dart';
import 'package:flutter_project_template/utils/constants/firestore/collections/User.dart';
import 'package:flutter_project_template/utils/utils.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:tuple/tuple.dart';

class UserRepository{

  static final CollectionReference _collectionReference =
            Firestore.instance.collection(FirestoreCollections.USER_COLLECTION);
  static final StorageReference _storageReference =
                  FirebaseStorage.instance.ref()
                      .child(StorageConstants.IMAGES_DIRECTORY_NAME)
                      .child(StorageConstants.USER_DIRECTORY_NAME);

  static Future<UserModel> getUserFromCredentials(FirebaseUser user, {bool cache = false}) async{
    DocumentSnapshot userDoc = await DocumentService.getDoc(
        _collectionReference.document(user.uid),
        cache);
    if(!userDoc.exists) return null;
    return getByDocSnap(userDoc, user: user);
  }

  static UserModel getByDocSnap(DocumentSnapshot docSnap,
                                      {FirebaseUser user}){
    return UserModel(
      id: docSnap.documentID,
      name: docSnap[UserCollectionNames.NAME],
      photoUrl: docSnap[UserCollectionNames.PHOTO_URL],
      photoUrlBig: docSnap[UserCollectionNames.PHOTO_URL_BIG],
      firebaseUser: user,
    );
  }

  static Future<Tuple2<UserModel, FirstLogin>> getCreateUser(FirebaseUser user,
                      {LoginType loginType = LoginType.EMAIL_LOGIN_TYPE}) async{
    DocumentReference docRef = _collectionReference.document(user.uid);
    DocumentSnapshot docSnap = await DocumentService.getDoc(
        docRef, false, forceServer: true);
    if(docSnap == null) return null;
    bool firstLogin = !docSnap.exists;
    if(firstLogin){
      String photoUrlBig;
      String photoUrl;
      switch(loginType){
        case LoginType.EMAIL_LOGIN_TYPE: {
          photoUrl = AppConfiguration.DEFAULT_PROFILE_IMAGE;
          photoUrlBig = AppConfiguration.DEFAULT_BIG_PROFILE_IMAGE;
          break;
        }
        case LoginType.GMAIL_LOGIN_TYPE: {
          photoUrl = Utils.getGmailProfileUrl(user.photoUrl, false);
          photoUrlBig = Utils.getGmailProfileUrl(user.photoUrl, true);
          break;
        }
        case LoginType.FACEBOOK_LOGIN_TYPE: {
          photoUrl = Utils.getFacebookProfileUrl(user.photoUrl, false);
          photoUrlBig = Utils.getFacebookProfileUrl(user.photoUrl, true);
          break;
        }
        default:
          photoUrl = user.photoUrl;
          photoUrlBig = user.photoUrl;
          break;
      }
      File profileFile = await Utils.getImageFromUrl(user.uid, photoUrl);
      File profileBigFile = await Utils.getImageFromUrl(user.uid + '_big', photoUrlBig);
      Tuple2<String, String> urls = await UserRepository._updateProfileImages(user.uid, profileFile, profileBigFile);

      await docRef.setData({
        UserCollectionNames.NAME: user.displayName,
        UserCollectionNames.PHOTO_URL: urls.item1,
        UserCollectionNames.PHOTO_URL_BIG: urls.item2,
      });
      docSnap = await DocumentService.getDoc(docRef, false, forceServer: true);
    }
    UserModel resUser = getByDocSnap(docSnap, user: user);
    return Tuple2<UserModel, FirstLogin>(
        resUser,
        firstLogin ? FirstLogin.FALSE : FirstLogin.TRUE,
    );
  }

  static Future<void> updateUser(String userId,
                                  {String name,
                                  File profileImage}) async{
    if(!AuthService.isLoggedIn()) return;
    Map<String, dynamic> data = Map();
    if(name != null) {
      data['name'] = name;
    }
    if(profileImage != null){
      //TODO
      /*
      var photoUrl = await _updateProfileImage(AuthController.appUser.id, profileImage);
      data['photoUrl'] = photoUrl;
      AuthController.appUser.photoUrl = photoUrl;
       */
    }
    if(data.isNotEmpty){
      DocumentReference userRef = _collectionReference.document(userId);
      userRef.updateData(data);
    }
  }




  //############################################################################


  static Future<void> updateDevice(String uid) async{
    // TODO FCM
    String deviceId = await FlutterUdid.udid;
    //String token = await FCM.getFcmToken();
    _collectionReference.document(uid)
        .collection(FirestoreCollections.USER_DEVICES_COLLECTION)
        .document(deviceId).setData({
      DevicesCollectionNames.FCM_TOKEN: null, //TODO
      DevicesCollectionNames.PLATFORM: Platform.operatingSystem,
    });
  }

  static Future<void> deleteDevice(String uid) async{
    String deviceId = await FlutterUdid.udid;
    _collectionReference.document(uid)
        .collection(FirestoreCollections.USER_DEVICES_COLLECTION)
        .document(deviceId).delete();
  }

  static Future<List<String>> getDevicesTokens(String uid) async{
    List<String> res = List();
    CollectionReference ref = _collectionReference.document(uid).collection(FirestoreCollections.USER_DEVICES_COLLECTION);
    QuerySnapshot query = await DocumentService.getAll(ref, false, forceServer: true);
    if(query == null) return res;
    for(DocumentSnapshot doc in query.documents){
      res.add(doc[DevicesCollectionNames.FCM_TOKEN]);
    }
    return res;
  }

  static Future<Tuple2<String, String>> _updateProfileImages(String uid, File profile, File profileBig) async{
    String profileFilename = uid + '.jpg';
    String profileBigFilename = uid + '_big.jpg';
    StorageUploadTask taskProfile;
    StorageUploadTask taskProfileBig;
    taskProfile = _storageReference.child(profileFilename).putFile(
        profile,
        StorageMetadata(
          contentType: 'image/jpg',
        )
    );
    taskProfileBig = _storageReference.child(profileBigFilename).putFile(
        profileBig,
        StorageMetadata(
          contentType: 'image/jpg',
        )
    );
    await taskProfile.onComplete;
    await taskProfileBig.onComplete;
    String profileUrl = await _storageReference.child(profileFilename).getDownloadURL();
    String profileBigUrl = await _storageReference.child(profileBigFilename).getDownloadURL();
    return Tuple2<String,String>(profileUrl, profileBigUrl);
  }

}