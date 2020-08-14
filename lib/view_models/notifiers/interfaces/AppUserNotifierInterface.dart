import 'package:flutter_project_template/models/UserModel.dart';
import 'package:flutter_project_template/utils/constants/enums/AppEnums.dart';
import 'package:flutter_project_template/utils/constants/enums/UserEnums.dart';

abstract class AppUserNotifierInterface{

  /// Logged User of the app
  UserModel get appUser => _appUser;

  /// True if the device supports Apple Sign In
  bool get supportsAppleSignIn => _supportsAppleSignIn;

  /// Gets the session of the logged user
  ///
  /// * This function have to be called on start of the app
  Future<NotifierState> initialVerification({bool fromCache = false});

  /// Sign In with email and password
  Future<LoginState> emailPasswordSignIn(String email, String password);

  /// Sign Up with email and password
  ///
  /// It sends and email verification.
  Future<LoginState> emailPasswordSignUp(String email, String password, String name);

  /// Function that has the functionality of Sign In and Sign Up with Google
  ///
  /// With Google, email verification is not necessary.
  Future<LoginState> googleSignIn();

  /// Function that has the functionality of Sign In and Sign Up with Facebook
  ///
  /// If is the first login, then it sends an email verification.
  //Future<LoginState> facebookSignIn();

  /// Function that has the functionality of Sign In and Sign Up with Apple
  Future<LoginState> appleSignIn();

  /// Sign Out the session of the user.
  Future<NotifierState> signOut();

  /// Private Stuff
  UserModel _appUser;
  bool _supportsAppleSignIn = false;

}