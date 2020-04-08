import 'package:firebase_auth/firebase_auth.dart';

class UserModel{

  String id;
  String name;
  String photoUrl;
  String photoUrlBig;
  FirebaseUser firebaseUser;

  UserModel({
    this.id,
    this.name,
    this.photoUrl,
    this.photoUrlBig,
    this.firebaseUser,
  });

}