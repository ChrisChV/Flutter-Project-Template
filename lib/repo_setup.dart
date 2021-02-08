import 'package:flutter_project_template/repositories/ArticleRepository.dart';
import 'package:flutter_project_template/repositories/UserRepository.dart';
import 'package:get/get.dart';

class RepoSetup{

  void init(){

    Get.put<UserRepository>(UserRepository(), permanent: true);
    Get.put<ArticleRepository>(ArticleRepository(), permanent: true);

  }

}