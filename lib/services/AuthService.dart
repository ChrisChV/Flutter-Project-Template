import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_project_template/AppConfiguration.dart';
import 'package:flutter_project_template/utils/constants/enums/UserEnums.dart';
import 'package:flutter_project_template/utils/exceptions/LoginExceptions.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:paulonia_error_service/paulonia_error_service.dart';

class AuthService{

  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  
  /// For facebook login, a Facebook App is needed
  //static final _facebookLogin = FacebookLogin();

  /// Verify if there is a user session is active
  static bool isLoggedIn(){
    return _auth.currentUser != null;
  }

  /// Returns the current user session
  static User initialVerification({bool cache = false}){
    return _auth.currentUser;
  }

  /// Sign Up with email an password
  ///
  /// It sends an email verification
  static Future<User> emailPasswordSignUp(
      String email, String password, String name) async {
    try{
      User user = (await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      )).user;
      await user.updateProfile(
        displayName: name,
        photoURL: AppConfiguration.DEFAULT_PROFILE_IMAGE,
      );
      await user.reload();
      user = _auth.currentUser;
      user.sendEmailVerification();
      return user;
    }
    catch(error){
     throw(_handlerLoginError(error));
    }
  }

  /// Sign in with email and password
  static Future<User> emailPasswordSignIn(String email, String password) async {
    try{
      final User user = (await _auth.signInWithEmailAndPassword(
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
  static Future<User> googleSignIn() async {
    try{
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
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
  static Future<User> facebookSignIn() async{
    try{
      final result = await _facebookLogin.logIn(['email']);
      final token = result.accessToken.token;

      final AuthCredential credential = FacebookAuthProvider.credential(token);
      User user = (await _auth.signInWithCredential(credential)).user;
      return user;
    }
    catch(error){
      throw(_handlerLoginError(error));
    }
  }
   */


  /// Function that has the functionality of Sign In and SignUp with Apple
  static Future<User> appleSignIn() async{
    try{
      final AuthorizationResult result = await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);
      switch(result.status){
        case AuthorizationStatus.authorized:
          final AppleIdCredential appleIdCredential = result.credential;
          OAuthProvider oAuthProvider = OAuthProvider("apple.com");
          final AuthCredential credential = oAuthProvider.credential(
            idToken: String.fromCharCodes(appleIdCredential.identityToken),
            accessToken: String.fromCharCodes(appleIdCredential.authorizationCode),
          );
          User user = (await _auth.signInWithCredential(credential)).user;
          String displayName = "${appleIdCredential.fullName.givenName}"
              "${appleIdCredential.fullName.familyName}";
          await user.updateProfile(displayName: displayName);
          await user.reload();
          user = _auth.currentUser;
          return user;
        case AuthorizationStatus.cancelled:
          throw(LoginCanceledException(""));
        case AuthorizationStatus.error:
          throw(_handlerLoginError(result.error));
      }
    }
    catch(error){
      throw(_handlerLoginError(error));
    }
  }

  /// Sends an email verification to [user]
  static void sendEmailVerification(User user){
    user.sendEmailVerification();
  }

  /// Sign Out the session of the user.
  static Future<void> signOut() async{
    //TODO Device token
    //String pastUid = appUser.id;
    //_facebookLogin.logOut();
    _googleSignIn.signOut();
    //_deleteDeviceToken(pastUid);
    _auth.signOut();
  }

  /// Handle all login errors
  static LoginState _handlerLoginError(dynamic error){
    signOut();
    if(error.runtimeType == NoSuchMethodError || error.code == null){
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
      case LoginErrorStrings.ERROR_TOO_MANY_REQUESTS:
        return LoginState.ERROR_TOO_MANY_REQUESTS;
      default:
        PauloniaErrorService.sendError(error);
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