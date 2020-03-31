import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_project_template/AppConfiguration.dart';
import 'package:flutter_project_template/controllers/UserController.dart';
import 'package:flutter_project_template/models/user.dart';
import 'package:flutter_project_template/utils/constants/TypesConstants.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tuple/tuple.dart';

class AuthService{

  static UserModel appUser;
  static bool firstLogin = false;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final facebookLogin = FacebookLogin();

  static bool isLoggedIn(){
    return appUser != null;
  }

  static Future<void> setAppUser({bool cache = false}) async{
    var user = await _auth.currentUser();
    if(user != null) appUser = await UserController.getUser(user, cache: cache);
    else appUser = null;
  }

  static Future<FirebaseUser> getCurrentFirebaseUser() async{
    return await _auth.currentUser();
  }

  static Future<void> emailPasswordSignUp(
      String email, String password, String name) async {
    FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    )).user;
    UserUpdateInfo info = new UserUpdateInfo();
    info.displayName = name;
    info.photoUrl = AppConfiguration.DEFAULT_PROFILE_IMAGE;
    await user.updateProfile(info);
    await user.reload();
    user = await _auth.currentUser();
    if(user != null) {
      Tuple2<UserModel, bool> result = await UserController.getCreateUser(
                        user, loginType:  TypesConstants.EMAIL_LOGIN_TYPE);
      appUser = result.item1;
      firstLogin = result.item2;
      _saveDeviceToken();
    }
  }

  static Future<void> emailPasswordSignIn(String email, String password) async {
    final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    )).user;
    if(user != null){
      appUser = await UserController.getUser(user);
      firstLogin = false;
      _saveDeviceToken();
    }
  }

  static Future<void> googleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    if(user != null){
      Tuple2<UserModel, bool> result = await UserController.getCreateUser(
          user, loginType: TypesConstants.GMAIL_LOGIN_TYPE);
      appUser = result.item1;
      firstLogin = result.item2;
      _saveDeviceToken();
    }
  }

  static Future<void> facebookSignIn() async{
    final result = await facebookLogin.logIn(['email']);
    print(result.errorMessage);
    final token = result.accessToken.token;

    final AuthCredential credential = FacebookAuthProvider.getCredential(
      accessToken: token,
    );

    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    if(user != null){
      Tuple2<UserModel, bool> result = await UserController.getCreateUser(
          user, loginType: TypesConstants.FACEBOOK_LOGIN_TYPE);
      appUser = result.item1;
      firstLogin = result.item2;
      _saveDeviceToken();
    }
  }

  static Future<void> signOut() async{
    String pastUid = appUser.id;
    facebookLogin.logOut();
    _googleSignIn.signOut();
    appUser = null;
    _deleteDeviceToken(pastUid);
    _auth.signOut();
  }

  static void _saveDeviceToken(){
    UserController.updateDevice(AuthService.appUser.id);
  }

  static Future<void> _deleteDeviceToken(String pastUid) async{
    UserController.deleteDevice(pastUid);
  }

}