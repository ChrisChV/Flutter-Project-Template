import 'package:flutter_project_template/repositories/ArticleRepository.dart';
import 'package:get/get.dart';
import 'package:paulonia_repository/RepoUpdate.dart';

class OtherArticleController extends GetxController{

  @override
  void onInit(){
    print('OtherArticleController init');
    _repository = Get.find();
    _repository.addListener(_handleChanges);
    super.onInit();
  }


  void printAll(){
    print(_repository.repositoryMap.keys.toList());
  }

  void _handleChanges(List<RepoUpdate> updates){
    for(var tt in updates){
      print(tt.modelId);
    }
  }

  ArticleRepository _repository;


}