import 'package:firebase_auth/firebase_auth.dart';

class UserModel{

  String id;
  String name;
  String gsUrl;
  String gsUrlBig;
  User firebaseUser; // Here is other information like email only when is logged

  int photoVersion; // Only for backend

  UserModel({
    this.id,
    this.name,
    this.gsUrl,
    this.gsUrlBig,
    this.firebaseUser,
    this.photoVersion,
  });

}