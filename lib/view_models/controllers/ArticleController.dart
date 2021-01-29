import 'package:flutter_project_template/models/ArticleModel.dart';
import 'package:flutter_project_template/repositories/ArticleRepository.dart';
import 'package:flutter_project_template/utils/constants/enums/AppEnums.dart';
import 'package:get/get.dart';

class ArticleController extends GetxController{

  List<ArticleModel> get articles => _articles;

  @override
  void onInit() {
    _repository = Get.find();
    _repository.addListener(_updateRepo);
    super.onInit();
  }

  Future<ControllerState> loadArticle({bool notify = true}) async{
    _articles = List();
    _articles.addAll(await _repository.getFromIdList(["Cl6vRq0QZVQEjL79D9PX", "ijnzWzeO3jncXLaBxHyi"], notify: true));
    return ControllerState.SUCCESS;
  }


  void _updateRepo(List<String> updatedIds){
    print("AAAAAAAAAAAAAAAAAa");
    print(updatedIds);
  }

  List<ArticleModel> _articles;
  ArticleRepository _repository;

}