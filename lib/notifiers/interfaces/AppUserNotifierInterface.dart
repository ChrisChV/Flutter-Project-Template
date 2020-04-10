import 'package:flutter_project_template/models/UserModel.dart';
import 'package:flutter_project_template/utils/constants/enums/AppEnums.dart';

abstract class AppUserNotifierInterface{

  UserModel _appUser;
  UserModel get appUser => _appUser;

  Future<NotifierState> initialVerification({bool fromCache = false});
  Future<NotifierState> emailPasswordSignIn(String email, String password);
  Future<NotifierState> googleSignIn();
  Future<NotifierState> signOut();

}