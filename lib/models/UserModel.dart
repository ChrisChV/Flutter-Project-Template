import 'package:firebase_auth/firebase_auth.dart';
import 'package:paulonia_repository/PauloniaModel.dart';

class UserModel implements PauloniaModel<String>{

  @override
  String id;
  String name;
  String gsUrl;
  String gsUrlBig;
  User firebaseUser; // Here is other information like email only when is logged

  int photoVersion; // Only for backend

  @override
  DateTime created;

  UserModel({
    this.id,
    this.name,
    this.gsUrl,
    this.gsUrlBig,
    this.firebaseUser,
    this.photoVersion,
  });

}