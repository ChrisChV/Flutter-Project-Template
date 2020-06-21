import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_project_template/AppConfiguration.dart';
import 'package:flutter_project_template/services/ErrorService.dart';
import 'package:flutter_project_template/utils/constants/enums/UserEnums.dart';
import 'package:flutter_project_template/utils/utils.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService{

  static FirebaseUser _currentUser;
  static bool firstLogin = false;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  
  /// For facebook login, a Facebook App is needed
  //static final facebookLogin = FacebookLogin(); 

  /// Verify if there is a user session is active
  static bool isLoggedIn(){
    return _currentUser != null;
  }

  /// Returns the current user session
  static Future<FirebaseUser> initialVerification({bool cache = false}) async{
    _currentUser = await _auth.currentUser();
    return _currentUser;
  }

  /// Sign Up with email an password
  ///
  /// It sends an email verification
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
      user = await _auth.currentUser();
      user.sendEmailVerification();
      return user;
    }
    catch(error){
     throw(_handlerLoginError(error));
    }
  }

  /// Sign in with email and password
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

  /// Function that has the functionality of Sign In and Sign Up with Google
  ///
  /// With Google, email verification is not necessary.
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

  /// Function that has the functionality of Sign In and Sign Up with Facebook
  /*
  static Future<FirebaseUser> facebookSignIn() async{
    try{
      final result = await _facebookLogin.logIn(['email']);
      print(result.errorMessage);
      final token = result.accessToken.token;

      final AuthCredential credential = FacebookAuthProvider.getCredential(
        accessToken: token,
      );
      FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
      return user;
    }
    catch(error){
      throw(_handlerLoginError(error));
    }
  }
  */

  /// Sends an email verification to [user]
  static void sendEmailVerification(FirebaseUser user){
    user.sendEmailVerification();
  }

  /// Sign Out the session of the user.
  static Future<void> signOut() async{
    //TODO Device token
    //String pastUid = appUser.id;
    //facebookLogin.logOut();
    _googleSignIn.signOut();
    _currentUser = null;
    //_deleteDeviceToken(pastUid);
    _auth.signOut();
  }

  /// Handle all login errors
  static LoginState _handlerLoginError(dynamic error){
    signOut();
    if(Utils.isOnWeb()){
      if(error.code == null){
        return LoginState.CANCELED_BY_THE_USER;
      }
      print(error.code);
      switch(error.code){
        case LoginErrorStringsWeb.ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL:
          return LoginState.ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL;
        case LoginErrorStringsWeb.ERROR_EMAIL_ALREADY_IN_USE:
          return LoginState.ERROR_EMAIL_ALREADY_IN_USE;
        case LoginErrorStringsWeb.ERROR_NETWORK_REQUEST_FAILED:
          return LoginState.ERROR_NETWORK_REQUEST_FAILED;
        case LoginErrorStringsWeb.ERROR_WEAK_PASSWORD:
          return LoginState.ERROR_WEAK_PASSWORD;
        case LoginErrorStringsWeb.ERROR_INVALID_EMAIL:
          return LoginState.ERROR_INVALID_EMAIL;
        case LoginErrorStringsWeb.ERROR_USER_NOT_FOUND:
          return LoginState.ERROR_USER_NOT_FOUND;
        case LoginErrorStringsWeb.ERROR_WRONG_PASSWORD:
          return LoginState.ERROR_WRONG_PASSWORD;
        default:
          ErrorService.sendError(error);
          return LoginState.UNKNOWN_ERROR;
      }
    }
    else{
      if(error.runtimeType == NoSuchMethodError){
        return LoginState.CANCELED_BY_THE_USER;
      }
      switch(error.code){
        case LoginErrorStringsMobile.ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL:
          return LoginState.ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL;
        case LoginErrorStringsMobile.ERROR_EMAIL_ALREADY_IN_USE:
          return LoginState.ERROR_EMAIL_ALREADY_IN_USE;
        case LoginErrorStringsMobile.ERROR_NETWORK_REQUEST_FAILED:
          return LoginState.ERROR_NETWORK_REQUEST_FAILED;
        case LoginErrorStringsMobile.ERROR_WEAK_PASSWORD:
          return LoginState.ERROR_WEAK_PASSWORD;
        case LoginErrorStringsMobile.ERROR_INVALID_EMAIL:
          return LoginState.ERROR_INVALID_EMAIL;
        case LoginErrorStringsMobile.ERROR_USER_NOT_FOUND:
          return LoginState.ERROR_USER_NOT_FOUND;
        case LoginErrorStringsMobile.ERROR_WRONG_PASSWORD:
          return LoginState.ERROR_WRONG_PASSWORD;
        default:
          ErrorService.sendError(error);
          return LoginState.UNKNOWN_ERROR;
      }
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