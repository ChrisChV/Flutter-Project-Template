import 'package:flutter_project_template/models/UserModel.dart';
import 'package:flutter_project_template/utils/constants/enums/AppEnums.dart';
import 'package:flutter_project_template/utils/constants/enums/UserEnums.dart';

abstract class AppUserNotifierInterface{

  UserModel _appUser;
  UserModel get appUser => _appUser;

  Future<NotifierState> initialVerification({bool fromCache = false});
  Future<LoginState> emailPasswordSignIn(String email, String password);
  Future<LoginState> googleSignIn();
  Future<NotifierState> signOut();

}