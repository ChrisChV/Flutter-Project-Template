import 'package:flutter_project_template/pack/PauloniaModel.dart';

class ArticleModel implements PauloniaModel<String>{

  @override
  String id;
  String title;
  String content;

  @override
  DateTime created;

  ArticleModel({
    this.id,
    this.title,
    this.content,
    this.created,
  });

}