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

  /// Load the first articles of the pagination
  Future<ControllerState> loadFirstArticles({bool notify = true}) async{
    _articles = await _repository.getArticles(resetPagination: true);
    if(notify) update();
    return ControllerState.SUCCESS;
  }

  /// Load the next articles of the pagination
  Future<ControllerState> loadNextArticles({bool notify = true}) async{
    List<ArticleModel> newArticles = await _repository.getArticles(notify: true);
    if(newArticles.isEmpty) return ControllerState.SUCCESS_EMPTY;
    _articles.addAll(newArticles);
    if(notify) update();
    return ControllerState.SUCCESS;
  }


  void _updateRepo(List<String> updatedIds){
    print("This is a little test. The updated ids are:");
    print(updatedIds);
  }

  List<ArticleModel> _articles;
  ArticleRepository _repository;

}