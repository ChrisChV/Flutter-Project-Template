import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_project_template/AppConfiguration.dart';
import 'package:flutter_project_template/models/UserModel.dart';
import 'package:flutter_project_template/utils/constants/SizesConstants.dart';
import 'package:flutter_project_template/utils/constants/enums/UserEnums.dart';
import 'package:flutter_project_template/utils/constants/storage/StorageConstants.dart';
import 'package:flutter_project_template/utils/constants/firestore/FirestoreConstants.dart';
import 'package:flutter_project_template/utils/constants/firestore/collections/Devices.dart';
import 'package:flutter_project_template/utils/constants/firestore/collections/User.dart';
import 'package:flutter_project_template/utils/utils.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:paulonia_document_service/paulonia_document_service.dart';
import 'package:paulonia_repository/PauloniaRepository.dart';
import 'package:paulonia_utils/paulonia_utils.dart';
import 'package:tuple/tuple.dart';

class UserRepository extends PauloniaRepository<String, UserModel>{

  @override
  CollectionReference get collectionReference => _collectionReference;

  CollectionReference _collectionReference =
            FirebaseFirestore.instance.collection(FirestoreCollections.USER_COLLECTION);

  Reference _storageReference = FirebaseStorage.instance.ref()
                          .child(StorageConstants.IMAGES_DIRECTORY_NAME)
                          .child(StorageConstants.USER_DIRECTORY_NAME);

  /// Gets an User from a logged FirebaseUser
  ///
  /// Set [cache] to true if you want to get the user from cache.
  Future<UserModel> getUserFromCredentials(User user, {bool cache = false}) async{
    DocumentSnapshot userDoc = await PauloniaDocumentService.getDoc(
      _collectionReference.doc(user.uid),
      cache
    );
    if(!userDoc.exists) return null;
    return getFromDocSnap(userDoc, user: user);
  }

  /// Get a user from a document snapshot
  @override
  UserModel getFromDocSnap(
    DocumentSnapshot docSnap, {
    User user
  }){
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
  Future<Tuple2<UserModel, FirstLogin>> getCreateUser(
    User user, {
    LoginType loginType = LoginType.EMAIL_LOGIN_TYPE
  }) async{
    DocumentReference docRef = _collectionReference.doc(user.uid);
    DocumentSnapshot docSnap = await PauloniaDocumentService.getDoc(
      docRef,
      false,
      forceServer: true
    );
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
          photoUrl = PUtils.getGmailProfileUrl(
              user.photoURL,
              SizesConstants.PROFILE_IMAGE_HEIGHT,
              SizesConstants.PROFILE_IMAGE_WIDTH
          );
          photoUrlBig = PUtils.getGmailProfileUrl(
              user.photoURL,
              SizesConstants.PROFILE_IMAGE_BIG_HEIGHT,
              SizesConstants.PROFILE_IMAGE_BIG_WIDTH
          );
          break;
        }
        case LoginType.FACEBOOK_LOGIN_TYPE: {
          photoUrl = PUtils.getFacebookProfileUrl(
              user.photoURL,
              SizesConstants.PROFILE_IMAGE_HEIGHT,
              SizesConstants.PROFILE_IMAGE_WIDTH
          );
          photoUrlBig = PUtils.getFacebookProfileUrl(
              user.photoURL,
              SizesConstants.PROFILE_IMAGE_BIG_HEIGHT,
              SizesConstants.PROFILE_IMAGE_BIG_WIDTH
          );
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
      if(loginType != LoginType.EMAIL_LOGIN_TYPE && !PUtils.isOnWeb()){
        /// TODO Test this part in web
        File profileFile = await Utils.getImageFromUrl(user.uid, photoUrl);
        File profileBigFile = await Utils.getImageFromUrl(user.uid + '_big', photoUrlBig);
        bool state = await _updateProfileImages(user.uid, 1, profileFile, profileBigFile);
        if(!state) data[UserCollectionNames.PHOTO_VERSION] = -1;
        else data[UserCollectionNames.PHOTO_VERSION] = 1;
      }
      else data[UserCollectionNames.PHOTO_VERSION] = -1;
      await docRef.set(data);
      docSnap = await PauloniaDocumentService.getDoc(docRef, false, forceServer: true);
    }
    UserModel resUser = getFromDocSnap(docSnap, user: user);
    return Tuple2<UserModel, FirstLogin>(
      resUser,
      firstLogin ? FirstLogin.TRUE : FirstLogin.FALSE,
    );
  }

  /// This function updates a user
  Future<Map<String, dynamic>> updateUser(
    UserModel user, {
    String name,
    File profileImage
  }) async{
    Map<String, dynamic> data = Map();
    if(name != null) data[UserCollectionNames.NAME] = name;
    if(profileImage != null){
      int photoVersion = user.photoVersion;
      if(user.photoVersion < 0) photoVersion = photoVersion * -1 + 1;
      else photoVersion += 1;
      bool state = await _updateProfileImage(user.id, photoVersion, profileImage);
      if(!state) return null;
      data[UserCollectionNames.PHOTO_VERSION] = photoVersion;
    }
    if(data.isNotEmpty){
      DocumentReference userRef = _collectionReference.doc(user.id);
      userRef.update(data);
    }
    return data;
  }


  Future<void> updateDevice(String uid) async{
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

  Future<void> deleteDevice(String uid) async{
    String deviceId = await FlutterUdid.udid;
    _collectionReference.doc(uid)
        .collection(FirestoreCollections.USER_DEVICES_COLLECTION)
        .doc(deviceId).delete();
  }

  Future<List<String>> getDevicesTokens(String uid) async{
    List<String> res = List();
    CollectionReference ref = _collectionReference.doc(uid).collection(FirestoreCollections.USER_DEVICES_COLLECTION);
    QuerySnapshot query = await PauloniaDocumentService.getAll(
      ref,
      false,
      forceServer: true
    );
    if(query == null) return res;
    for(QueryDocumentSnapshot doc in query.docs){
      res.add(doc.get(DevicesCollectionNames.FCM_TOKEN));
    }
    return res;
  }

  /// Compress, resize and uploads the profile image to Cloud Storage
  Future<bool> _updateProfileImage(
    String userId,
    int photoVersion,
    File profileImage
  ) async{
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
    return _updateProfileImages(userId, photoVersion, profile, profileBig);
  }

  /// This function stores the profile images to Cloud Storage
  Future<bool> _updateProfileImages(String userId, int photoVersion, File profile, File profileBig) async{
    try{
      String profileFilename = StorageConstants.SMALL_PREFIX + photoVersion.toString()
                                  + StorageConstants.JPG_EXTENSION;
      String profileBigFilename = StorageConstants.BIG_PREFIX + photoVersion.toString()
                                  + StorageConstants.JPG_EXTENSION;
      UploadTask taskProfile = _storageReference.child(userId).child(profileFilename).putFile(
          profile,
          SettableMetadata(
            contentType: 'image/jpg',
          )
      );
      UploadTask taskProfileBig = _storageReference.child(userId).child(profileBigFilename).putFile(
          profileBig,
          SettableMetadata(
            contentType: 'image/jpg',
          )
      );
      await taskProfile.whenComplete(() => null);
      await taskProfileBig.whenComplete(() => null);
      return true;
    }
    catch(error){
      return false;
    }
  }

  /// Gets the gs url for the profile image
  String _getGsUrl(String userId, int photoVersion){
    if(photoVersion > 0){
      return AppConfiguration.GS_BUCKET_URL + StorageConstants.IMAGES_DIRECTORY_NAME
          + '/' + StorageConstants.USER_DIRECTORY_NAME
          + '/' + userId + '/' + StorageConstants.SMALL_PREFIX
          + photoVersion.toString() + StorageConstants.JPG_EXTENSION;
    }
    return AppConfiguration.GS_BUCKET_URL + StorageConstants.IMAGES_DIRECTORY_NAME
          + '/' + StorageConstants.DEFAULT_DIRECTORY_NAME
          + '/' + StorageConstants.DEFAULT_USER + StorageConstants.JPG_EXTENSION;
  }

  /// Gets the gs url for the big profile image
  String _getBigGsUrl(String userId, int photoVersion){
    if(photoVersion > 0){
      return AppConfiguration.GS_BUCKET_URL + StorageConstants.IMAGES_DIRECTORY_NAME
          + '/' + StorageConstants.USER_DIRECTORY_NAME
          + '/' + userId + '/' + StorageConstants.BIG_PREFIX
          + photoVersion.toString() + StorageConstants.JPG_EXTENSION;
    }
    return AppConfiguration.GS_BUCKET_URL + StorageConstants.IMAGES_DIRECTORY_NAME
        + '/' + StorageConstants.DEFAULT_DIRECTORY_NAME
        + '/' + StorageConstants.DEFAULT_USER_BIG + StorageConstants.JPG_EXTENSION;

  }

}