import 'package:flutter_project_template/repositories/ArticleRepository.dart';
import 'package:get/get.dart';

class RepoSetup{

  void init(){

    Get.put<ArticleRepository>(ArticleRepository(), permanent: true);

  }

}