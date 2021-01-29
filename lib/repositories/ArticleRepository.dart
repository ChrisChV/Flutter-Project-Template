import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_project_template/models/ArticleModel.dart';
import 'package:flutter_project_template/pack/PauloniaRepository.dart';
import 'package:flutter_project_template/utils/constants/firestore/FirestoreConstants.dart';
import 'package:flutter_project_template/utils/constants/firestore/collections/Article.dart';

class ArticleRepository extends PauloniaRepository<String, ArticleModel>{

  @override
  CollectionReference get collectionReference => _collectionReference;

  CollectionReference _collectionReference = FirebaseFirestore.instance
                        .collection(FirestoreCollections.ARTICLE_COLLECTION);

  @override
  ArticleModel getFromDocSnap(DocumentSnapshot docSnap){
    return ArticleModel(
      id: docSnap.id,
      title: docSnap.get(ArticleCollectionNames.TITLE),
      content: docSnap.get(ArticleCollectionNames.CONTENT),
      created: docSnap.get(ArticleCollectionNames.CREATED)?.toDate(),
    );
  }

  /*
  @override
  Future<ArticleModel> getFromId(
    String id, {
    bool cache = false
  }) async{
    Query query = _collectionReference.where(FieldPath.documentId, isEqualTo: id);
    QuerySnapshot queryRes = await PauloniaDocumentService.runQuery(query, cache);
    if(queryRes.docs.isEmpty) return null;
    return getFromDocSnap(queryRes.docs.first);
  }

   */






}