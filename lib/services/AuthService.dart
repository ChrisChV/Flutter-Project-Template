import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_project_template/AppConfiguration.dart';
import 'package:flutter_project_template/services/ErrorService.dart';
import 'package:flutter_project_template/utils/constants/enums/UserEnums.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService{

  static FirebaseUser _currentUser;
  static bool firstLogin = false;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  
  /// For facebook login, a Facebook App is needed
  //static final facebookLogin = FacebookLogin(); 

  static bool isLoggedIn(){
    return _currentUser != null;
  }

  static Future<FirebaseUser> initialVerification({bool cache = false}) async{
    _currentUser = await _auth.currentUser();
    return _currentUser;
  }

  static Future<FirebaseUser> emailPasswordSignUp(
      String email, String password, String name) async {
    try{
      FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      )).user;
      UserUpdateInfo info = new UserUpdateInfo();
      info.displayName = name;
      info.photoUrl = AppConfiguration.DEFAULT_PROFILE_IMAGE;
      await user.updateProfile(info);
      await user.reload();
      return await _auth.currentUser();
    }
    catch(error){
     throw(_handlerLoginError(error));
    }
  }

  static Future<FirebaseUser> emailPasswordSignIn(String email, String password) async {
    try{
      final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).user;
      return user;
    }
    catch(error){
      throw(_handlerLoginError(error));
    }
  }

  static Future<FirebaseUser> googleSignIn() async {
    try{
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return (await _auth.signInWithCredential(credential)).user;
    }
    catch(error){
      throw(_handlerLoginError(error));
    }
  }

  /*
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
  */

  static Future<void> signOut() async{
    //TODO Device token
    //String pastUid = appUser.id;
    //facebookLogin.logOut();
    _googleSignIn.signOut();
    _currentUser = null;
    //_deleteDeviceToken(pastUid);
    _auth.signOut();
  }

  static LoginState _handlerLoginError(dynamic error){
    signOut();
    if(error.runtimeType == NoSuchMethodError){
      return LoginState.CANCELED_BY_THE_USER;
    }
    switch(error.code){
      case LoginErrorStrings.ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL:
        return LoginState.ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL;
      case LoginErrorStrings.ERROR_EMAIL_ALREADY_IN_USE:
        return LoginState.ERROR_EMAIL_ALREADY_IN_USE;
      case LoginErrorStrings.ERROR_NETWORK_REQUEST_FAILED:
        return LoginState.ERROR_NETWORK_REQUEST_FAILED;
      case LoginErrorStrings.ERROR_WEAK_PASSWORD:
        return LoginState.ERROR_WEAK_PASSWORD;
      case LoginErrorStrings.ERROR_INVALID_EMAIL:
        return LoginState.ERROR_INVALID_EMAIL;
      case LoginErrorStrings.ERROR_USER_NOT_FOUND:
        return LoginState.ERROR_USER_NOT_FOUND;
      case LoginErrorStrings.ERROR_WRONG_PASSWORD:
        return LoginState.ERROR_WRONG_PASSWORD;
      default:
        ErrorService.sendError(error);
        return LoginState.UNKNOWN_ERROR;
    }
  }

  /*
  static void _saveDeviceToken(){
    UserRepository.updateDevice(AuthService.appUser.id);
  }

  static Future<void> _deleteDeviceToken(String pastUid) async{
    UserRepository.deleteDevice(pastUid);
  }
  */

}