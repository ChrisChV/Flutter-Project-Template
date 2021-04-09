import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_project_template/models/ArticleModel.dart';
import 'package:flutter_project_template/utils/constants/firestore/FirestoreConstants.dart';
import 'package:flutter_project_template/utils/constants/firestore/collections/Article.dart';
import 'package:paulonia_document_service/paulonia_document_service.dart';
import 'package:paulonia_repository/PauloniaRepository.dart';
import 'package:paulonia_repository/RepoUpdate.dart';

class ArticleRepository extends PauloniaRepository<String, ArticleModel>{

  @override
  CollectionReference get collectionReference => _collectionReference;

  CollectionReference _collectionReference = FirebaseFirestore.instance
                        .collection(FirestoreCollections.ARTICLE_COLLECTION);

  DocumentSnapshot _articlePagination;

  /// Gets an article model from a document snapshot
  @override
  ArticleModel getFromDocSnap(DocumentSnapshot docSnap){
    return ArticleModel(
      id: docSnap.id,
      title: docSnap.get(ArticleCollectionNames.TITLE),
      content: docSnap.get(ArticleCollectionNames.CONTENT),
      created: docSnap.get(ArticleCollectionNames.CREATED)?.toDate(),
    );
  }

  /// Gets all articles sorted by created with pagination
  Future<List<ArticleModel>> getArticles({
    bool resetPagination = false,
    bool notify = false,
    bool cache = false,
  }) async{
    if(resetPagination) _articlePagination = null;
    Query query = _collectionReference
                  .orderBy(ArticleCollectionNames.CREATED, descending: true)
                  .limit(1);
    if(_articlePagination != null){
      query = query.startAfterDocument(_articlePagination);
    }
    QuerySnapshot queryRes = await PauloniaDocumentService.runQuery(query, cache);
    if(queryRes.docs.isEmpty) return [];
    _articlePagination = queryRes.docs.last;
    List<ArticleModel> res = await getFromDocSnapList(queryRes.docs);
    addInRepository(res);
    if(notify) update(RepoUpdateType.get, models: res);
    return res;
  }



}