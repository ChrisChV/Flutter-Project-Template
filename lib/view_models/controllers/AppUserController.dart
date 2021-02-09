import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_project_template/models/UserModel.dart';
import 'package:flutter_project_template/repositories/UserRepository.dart';
import 'package:flutter_project_template/services/AuthService.dart';
import 'package:flutter_project_template/utils/constants/enums/AppEnums.dart';
import 'package:flutter_project_template/utils/constants/enums/UserEnums.dart';
import 'package:flutter_project_template/utils/exceptions/LoginExceptions.dart';
import 'package:get/get.dart';
import 'package:paulonia_error_service/paulonia_error_service.dart';
import 'package:paulonia_utils/paulonia_utils.dart';
import 'package:tuple/tuple.dart';

class AppUserController extends GetxController{

  /// Logged user
  UserModel get appUser => _appUser;

  /// Verifies if is the first login of [appUser]
  bool get firstLogin => _firstLogin == FirstLogin.TRUE;

  /// Verifies if the device supports Apple Sign In
  bool get supportsAppleSignIn => _supportsAppleSignIn;

  @override
  void onInit(){
    _repository = Get.find();
    super.onInit();
  }

  /// Verify if there is a user session is active
  bool isLoggedIn(){
    return _appUser != null;
  }

  /// Gets the session of the logged user
  ///
  /// * This function have to be called on start of the app
  Future<ControllerState> initialVerification({
    bool notify = true
  }) async{
    _supportsAppleSignIn = await PUtils.supportsAppleSignIn();
    User user = AuthService.initialVerification();
    if(user == null) return ControllerState.SUCCESS;
    _appUser = await _repository.getUserFromCredentials(user, cache: false);
    if(_appUser == null) AuthService.signOut();
    else {
      if (notify) update();
      await _loginSuccess(initialVerification: true);
    }
    return ControllerState.SUCCESS;
  }

  /// Sign In with email and password
  Future<LoginState> emailPasswordSignIn(
    String email,
    String password, {
    bool notify = true,
  }) async{
    try{
      if(_appUser != null){
        PauloniaErrorService.sendError(BadLoginException());
        return LoginState.ERROR_BAD_LOGIN;
      }
      User user = await AuthService.emailPasswordSignIn(email, password);
      if(user == null) return LoginState.ERROR_BAD_LOGIN;
      _appUser = await _repository.getUserFromCredentials(user);
      if(_appUser == null){
        AuthService.signOut();
        return LoginState.ERROR_BAD_LOGIN;
      }
      await _loginSuccess();
      if(notify) update();
      return LoginState.SUCCESS;
    }
    catch(state){
      if(state.runtimeType == LoginState) return state;
      PauloniaErrorService.sendError(state);
      return LoginState.ERROR_BAD_LOGIN;
    }
  }

  /// Sign Up with email and password
  ///
  /// It sends and email verification.
  Future<LoginState> emailPasswordSignUp(
    String email,
    String password,
    String name, {
    bool notify = true,
  }) async{
    try{
      if(_appUser != null){
        PauloniaErrorService.sendError(BadLoginException());
        return LoginState.ERROR_BAD_LOGIN;
      }
      User user = await AuthService.emailPasswordSignUp(email, password, name);
      if(user == null) return LoginState.ERROR_BAD_LOGIN;
      Tuple2<UserModel, FirstLogin> result = await _repository.getCreateUser(
          user, loginType: LoginType.EMAIL_LOGIN_TYPE
      );
      _appUser = result.item1;
      _firstLogin = result.item2;
      if(_appUser == null){
        AuthService.signOut();
        return LoginState.ERROR_BAD_LOGIN;
      }
      if(notify) update();
      await _loginSuccess();
      return LoginState.SUCCESS;
    }
    catch(state){
      if(state.runtimeType == LoginState) return state;
      PauloniaErrorService.sendError(state);
      return LoginState.ERROR_BAD_LOGIN;
    }
  }

  /// Function that has the functionality of Sign In and Sign Up with Google
  ///
  /// With Google, email verification is not necessary.
  Future<LoginState> googleSignIn({bool notify = true}) async{
    try{
      if(_appUser != null){
        PauloniaErrorService.sendError(BadLoginException());
        return LoginState.ERROR_BAD_LOGIN;
      }
      User user = await AuthService.googleSignIn();
      if(user == null) return LoginState.ERROR_BAD_LOGIN;
      Tuple2<UserModel, FirstLogin> result = await _repository.getCreateUser(
          user, loginType: LoginType.GMAIL_LOGIN_TYPE);
      _appUser = result.item1;
      _firstLogin = result.item2;
      if(_appUser == null){
        AuthService.signOut();
        return LoginState.ERROR_BAD_LOGIN;
      }
      update();
      await _loginSuccess();
      return LoginState.SUCCESS;
    }
    catch(state){
      if(state.runtimeType == LoginState) return state;
      PauloniaErrorService.sendError(state);
      return LoginState.ERROR_BAD_LOGIN;
    }
  }

  /// Function that has the functionality of Sign In and Sign Up with Facebook
  ///
  /// If is the first login, then it sends an email verification.
  /*
  Future<LoginState> facebookSignIn({bool notify = true}) async{
    try{
      if(_appUser != null){
        PauloniaErrorService.sendError(BadLoginException());
        return LoginState.ERROR_BAD_LOGIN;
      }
      User user = await AuthService.facebookSignIn();
      if(user == null) return LoginState.ERROR_BAD_LOGIN;
      Tuple2<UserModel, FirstLogin> result = await UserRepository.getCreateUser(
          user, loginType: LoginType.FACEBOOK_LOGIN_TYPE);
      _appUser = result.item1;
      _firstLogin = result.item2;
      if(_appUser == null){
        AuthService.signOut();
        return LoginState.ERROR_BAD_LOGIN;
      }
      if(notify) update();
      await _loginSuccess();
      return LoginState.SUCCESS;
    }
    catch(state){
      if(state.runtimeType == LoginState) return state;
      PauloniaErrorService.sendError(state);
      return LoginState.ERROR_BAD_LOGIN;
    }
  }
   */


  /// Function that has the functionality of Sign In and Sign Up with Apple
  Future<LoginState> appleSignIn({bool notify = true}) async{
    try{
      if(_appUser != null){
        PauloniaErrorService.sendError(BadLoginException());
        return LoginState.ERROR_BAD_LOGIN;
      }
      User user = await AuthService.appleSignIn();
      if(user == null) return LoginState.ERROR_BAD_LOGIN;
      Tuple2<UserModel, FirstLogin> result = await _repository.getCreateUser(
          user, loginType: LoginType.EMAIL_LOGIN_TYPE);
      _appUser = result.item1;
      _firstLogin = result.item2;
      if(_appUser == null){
        AuthService.signOut();
        return LoginState.ERROR_BAD_LOGIN;
      }
      if(notify) update();
      await _loginSuccess();
      return LoginState.SUCCESS;
    }
    catch(state){
      if(state.runtimeType == LoginState) return state;
      PauloniaErrorService.sendError(state);
      return LoginState.ERROR_BAD_LOGIN;
    }
  }

  /// Sign Out the session of the user.
  Future<ControllerState> signOut({bool notify = true}) async{
    AuthService.signOut();
    _appUser = null;
    _firstLogin = FirstLogin.FALSE;

    /// Here put all clear functions of the controllers

    if(notify) update();
    return ControllerState.SUCCESS;
  }

  /// Function that calls all the necessary after a success login
  Future<void> _loginSuccess({bool initialVerification = false}) async{
    /// Here make that in a success login
  }

  /// Private stuff

  UserModel _appUser;
  bool _supportsAppleSignIn = false;
  FirstLogin _firstLogin = FirstLogin.FALSE;
  UserRepository _repository;

}