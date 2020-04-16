import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_project_template/models/UserModel.dart';
import 'package:flutter_project_template/notifiers/interfaces/AppUserNotifierInterface.dart';
import 'package:flutter_project_template/pages/Login.dart';
import 'package:flutter_project_template/repositories/UserRepository.dart';
import 'package:flutter_project_template/services/AuthService.dart';
import 'package:flutter_project_template/services/ErrorService.dart';
import 'package:flutter_project_template/utils/constants/enums/AppEnums.dart';
import 'package:flutter_project_template/utils/constants/enums/UserEnums.dart';
import 'package:flutter_project_template/utils/exceptions/LoginExceptions.dart';
import 'package:tuple/tuple.dart';

class AppUserNotifier extends ChangeNotifier implements AppUserNotifierInterface{

  UserModel _appUser;
  UserModel get appUser => _appUser;

  bool isLoggedIn(){
    return _appUser != null;
  }

  @override
  Future<NotifierState> initialVerification({bool fromCache = false}) async{
    FirebaseUser user = await AuthService.initialVerification();
    if(user == null) return NotifierState.SUCCESS;
    _appUser = await UserRepository.getUserFromCredentials(user, cache: fromCache);
    if(_appUser == null) AuthService.signOut();
    else notifyListeners();
    return NotifierState.SUCCESS;
  }

  @override
  Future<LoginState> emailPasswordSignIn(String email, String password) async{
    //TODO verificar errores lanzados por AuthService en todos los singIn
    try{
      if(_appUser != null){
        ErrorService.sendError(BadLoginException());
        return LoginState.ERROR_BAD_LOGIN;
      }
      FirebaseUser user = await AuthService.emailPasswordSignIn(email, password);
      if(user == null) return LoginState.ERROR_BAD_LOGIN;
      _appUser = await UserRepository.getUserFromCredentials(user);
      if(_appUser == null){
        AuthService.signOut();
        return LoginState.ERROR_BAD_LOGIN;
      }
      notifyListeners();
      return LoginState.SUCCESS;
    }
    catch(state){
      if(state.runtimeType == LoginState) return state;
      ErrorService.sendError(state);
    }
  }

  @override
  Future<LoginState> googleSignIn() async{
    try{
      if(_appUser != null){
        ErrorService.sendError(BadLoginException());
        return LoginState.ERROR_BAD_LOGIN;
      }
      FirebaseUser user = await AuthService.googleSignIn();
      if(user == null) return LoginState.ERROR_BAD_LOGIN;
      Tuple2<UserModel, FirstLogin> result = await UserRepository.getCreateUser(
          user, loginType: LoginType.GMAIL_LOGIN_TYPE);
      _appUser = result.item1;
      notifyListeners();
      return LoginState.SUCCESS;
    }
    catch(state){
      if(state.runtimeType == LoginState) return state;
      ErrorService.sendError(state);
    }
  }

  @override
  Future<NotifierState> signOut() async{
    AuthService.signOut();
    _appUser = null;
    notifyListeners();
    return NotifierState.SUCCESS;
  }


}