import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_project_template/AppConfiguration.dart';
import 'package:flutter_project_template/models/UserModel.dart';
import 'package:flutter_project_template/services/DocumentService.dart';
import 'package:flutter_project_template/services/platforms/firebase/firebase.dart';
import 'package:flutter_project_template/utils/constants/SizesConstants.dart';
import 'package:flutter_project_template/utils/constants/enums/AppEnums.dart';
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
            FirebaseFirestore.instance.collection(FirestoreCollections.USER_COLLECTION);

  static final _storageReference = FirebaseService.getStorageReference([
    StorageConstants.IMAGES_DIRECTORY_NAME,
    StorageConstants.USER_DIRECTORY_NAME,
  ]);

  /// Gets an User from a logged FirebaseUser
  ///
  /// Set [cache] to true if you want to get the user from cache.
  static Future<UserModel> getUserFromCredentials(User user, {bool cache = false}) async{
    DocumentSnapshot userDoc = await DocumentService.getDoc(
        _collectionReference.doc(user.uid),
        cache);
    if(!userDoc.exists) return null;
    return getByDocSnap(userDoc, user: user);
  }

  /// Get a user from a document snapshot
  static UserModel getByDocSnap(DocumentSnapshot docSnap,
      {User user}){
    int photoVersion = docSnap.get(UserCollectionNames.PHOTO_VERSION);
    return UserModel(
      id: docSnap.id,
      name: docSnap.get(UserCollectionNames.NAME),
      gsUrl: _getGsUrl(docSnap.id, photoVersion),
      gsUrlBig: _getBigGsUrl(docSnap.id, photoVersion),
      photoVersion: docSnap.get(UserCollectionNames.PHOTO_VERSION),
      firebaseUser: user,
    );
  }

  /// This function get a user
  ///
  /// This function returns a tuple of the user and a value that indicates if
  /// is the first login of the user or not.
  /// If the user does not exist in the database, then this function creates it.
  /// The [loginType] is used to get the image profile, that is different for
  /// each type of login.
  static Future<Tuple2<UserModel, FirstLogin>> getCreateUser(
      User user, {
      LoginType loginType = LoginType.EMAIL_LOGIN_TYPE
  }) async{
    DocumentReference docRef = _collectionReference.doc(user.uid);
    DocumentSnapshot docSnap = await DocumentService.getDoc(
        docRef, false, forceServer: true);
    if(docSnap == null) return null;
    bool firstLogin = !docSnap.exists;
    if(firstLogin){
      String photoUrlBig;
      String photoUrl;
      switch(loginType){
        case LoginType.EMAIL_LOGIN_TYPE: {
          break;
        }
        case LoginType.GMAIL_LOGIN_TYPE: {
          photoUrl = Utils.getGmailProfileUrl(user.photoURL, false);
          photoUrlBig = Utils.getGmailProfileUrl(user.photoURL, true);
          break;
        }
        case LoginType.FACEBOOK_LOGIN_TYPE: {
          photoUrl = Utils.getFacebookProfileUrl(user.photoURL, false);
          photoUrlBig = Utils.getFacebookProfileUrl(user.photoURL, true);
          break;
        }
        default:
          photoUrl = user.photoURL;
          photoUrlBig = user.photoURL;
          break;
      }
      Map<String, dynamic> data = {
        UserCollectionNames.NAME: user.displayName,
        UserCollectionNames.CREATED: FieldValue.serverTimestamp(),
      };
      if(loginType != LoginType.EMAIL_LOGIN_TYPE){
        File profileFile = await Utils.getImageFromUrl(user.uid, photoUrl);
        File profileBigFile = await Utils.getImageFromUrl(user.uid + '_big', photoUrlBig);
        bool state = await _updateProfileImages(user.uid, profileFile, profileBigFile);
        if(!state) data[UserCollectionNames.PHOTO_VERSION] = -1;
        else data[UserCollectionNames.PHOTO_VERSION] = 1;
      }
      else data[UserCollectionNames.PHOTO_VERSION] = -1;
      await docRef.set(data);
      docSnap = await DocumentService.getDoc(docRef, false, forceServer: true);
    }
    UserModel resUser = getByDocSnap(docSnap, user: user);
    return Tuple2<UserModel, FirstLogin>(
      resUser,
      firstLogin ? FirstLogin.TRUE : FirstLogin.FALSE,
    );
  }

  /// This function updates a user
  static Future<Map<String, dynamic>> updateUser(
    UserModel user, {
    String name,
    File profileImage
  }) async{
    Map<String, dynamic> data = Map();
    if(name != null) data[UserCollectionNames.NAME] = name;
    if(profileImage != null){
      bool state = await _updateProfileImage(user.id, profileImage);
      if(!state) return null;
      int photoVersion = user.photoVersion;
      if(user.photoVersion < 0) photoVersion = photoVersion * -1 + 1;
      else photoVersion += 1;
      data[UserCollectionNames.PHOTO_VERSION] = photoVersion;
    }
    if(data.isNotEmpty){
      DocumentReference userRef = _collectionReference.doc(user.id);
      userRef.update(data);
    }
    return data;
  }


  static Future<void> updateDevice(String uid) async{
    // TODO FCM
    String deviceId = await FlutterUdid.udid;
    //String token = await FCM.getFcmToken();
    _collectionReference.doc(uid)
        .collection(FirestoreCollections.USER_DEVICES_COLLECTION)
        .doc(deviceId).set({
      DevicesCollectionNames.FCM_TOKEN: null, //TODO
      DevicesCollectionNames.PLATFORM: Platform.operatingSystem,
    });
  }

  static Future<void> deleteDevice(String uid) async{
    String deviceId = await FlutterUdid.udid;
    _collectionReference.doc(uid)
        .collection(FirestoreCollections.USER_DEVICES_COLLECTION)
        .doc(deviceId).delete();
  }

  static Future<List<String>> getDevicesTokens(String uid) async{
    List<String> res = List();
    CollectionReference ref = _collectionReference.doc(uid).collection(FirestoreCollections.USER_DEVICES_COLLECTION);
    QuerySnapshot query = await DocumentService.getAll(ref, false, forceServer: true);
    if(query == null) return res;
    for(QueryDocumentSnapshot doc in query.docs){
      res.add(doc.get(DevicesCollectionNames.FCM_TOKEN));
    }
    return res;
  }

  /// Compress, resize and uploads the profile image to Cloud Storage
  static Future<bool> _updateProfileImage(String userId, File profileImage) async{
    File profile = await FlutterNativeImage.compressImage(
      profileImage.path,
      quality: 70,
      targetWidth: SizesConstants.PROFILE_IMAGE_WIDTH,
      targetHeight: SizesConstants.PROFILE_IMAGE_HEIGHT,
    );
    File profileBig = await FlutterNativeImage.compressImage(
      profileImage.path,
      quality: 70,
      targetWidth: SizesConstants.PROFILE_IMAGE_BIG_WIDTH,
      targetHeight: SizesConstants.PROFILE_IMAGE_BIG_HEIGHT,
    );
    return _updateProfileImages(userId, profile, profileBig);
  }

  /// This function stores the profile images to Cloud Storage
  static Future<bool> _updateProfileImages(String uid, File profile, File profileBig) async{
    try{
      String profileFilename = StorageConstants.SMALL_PREFIX + StorageConstants.JPG_EXTENSION;
      String profileBigFilename = StorageConstants.BIG_PREFIX + StorageConstants.JPG_EXTENSION;
      await FirebaseService.putFile(
          _storageReference.child(uid).child(profileFilename),
          profile,
          StorageFileType.IMAGE_JPG
      );
      await FirebaseService.putFile(
          _storageReference.child(uid).child(profileBigFilename),
          profileBig,
          StorageFileType.IMAGE_JPG
      );
      return true;
    }
    catch(error){
      return false;
    }
  }

  static String _getGsUrl(String userId, int photoVersion){
    return AppConfiguration.GS_BUCKET_URL + StorageConstants.USER_DIRECTORY_NAME
        + '/' + userId + '/' + StorageConstants.SMALL_PREFIX + '_'
        + photoVersion.toString() + StorageConstants.JPG_EXTENSION;
  }

  static String _getBigGsUrl(String userId, int photoVersion){
    return AppConfiguration.GS_BUCKET_URL + StorageConstants.USER_DIRECTORY_NAME
        + '/' + userId + '/' + StorageConstants.BIG_PREFIX + '_'
        + photoVersion.toString() + StorageConstants.JPG_EXTENSION;
  }

}