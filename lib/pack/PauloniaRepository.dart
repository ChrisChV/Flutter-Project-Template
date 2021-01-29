import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_project_template/pack/PauloniaModel.dart';
import 'package:flutter_project_template/utils/constants/firestore/FirestoreConstants.dart';
import 'package:get/get.dart';
import 'package:paulonia_document_service/paulonia_document_service.dart';

abstract class PauloniaRepository<Id, Model extends PauloniaModel<Id>>
        extends GetxService{

  CollectionReference get collectionReference => _collectionReference;

  final HashMap<Id, Model> repositoryMap = HashMap();

  Model getFromDocSnap(DocumentSnapshot docSnap);

  Future<List<Model>> getFromDocSnapList(List<DocumentSnapshot> docSnapList) async{
    List<Model> res = [];
    for(DocumentSnapshot docSnap in docSnapList){
      res.add(getFromDocSnap(docSnap));
    }
    return res;
  }

  Future<Model> getFromId(
    Id id, {
    bool cache = false,
    bool refreshRepoData = false,
    bool notify = false,
  }) async{
    if(!refreshRepoData){
      Model res = repositoryMap[id];
      if(res != null) return res;
    }
    Query query = collectionReference.where(FieldPath.documentId, isEqualTo: id);
    QuerySnapshot queryRes = await PauloniaDocumentService.runQuery(query, cache);
    if(queryRes.docs.isEmpty) return null;
    Model res = getFromDocSnap(queryRes.docs.first);
    repositoryMap[id] = res;
    if(notify) _update([id]);
    return res;
  }

  Future<List<Model>> getFromIdList(
    List<Id> idList, {
    bool cache = false,
    bool refreshRepoData = false,
    bool notify = false,
  }) async{
    List<Id> _idList = [];
    List<Model> res = [];
    if(!refreshRepoData){
      Model modelRes;
      for(Id id in idList){
        modelRes = repositoryMap[id];
        if(modelRes != null) res.add(modelRes);
        else _idList.add(id);
      }
    }
    else _idList = idList;
    List<Model> newModels = [];
    if(_idList.length <= FirestoreConstants.ARRAY_QUERIES_ITEM_LIMIT){
      newModels.addAll(await _getFromIdList(_idList, cache: cache));
      addInRepository(newModels);
      if(_idList.isNotEmpty && notify) _update(_idList);
      res.addAll(newModels);
      return res;
    }
    int start = 0;
    int end = FirestoreConstants.ARRAY_QUERIES_ITEM_LIMIT;
    while(true){
      if(end > _idList.length) end = _idList.length;
      if(end == start) break;
      newModels.addAll(await _getFromIdList(_idList.getRange(start, end).toList(), cache: cache));
      start = end;
      end += FirestoreConstants.ARRAY_QUERIES_ITEM_LIMIT;
    }
    addInRepository(newModels);
    if(_idList.isNotEmpty && notify) _update(_idList);
    res.addAll(newModels);
    return res;
  }

  void addInRepository(List<Model> models){
    for(Model model in models){
      repositoryMap[model.id] = model;
    }
  }

  Future<List<Model>> _getFromIdList(
    List<Id> idList, {
    bool cache = false,
  }) async{
    if(idList.length > FirestoreConstants.ARRAY_QUERIES_ITEM_LIMIT){
      return null;
    }
    if(idList.isEmpty) return [];
    Query query = collectionReference
                  .where(FieldPath.documentId, whereIn: idList)
                  .limit(FirestoreConstants.ARRAY_QUERIES_ITEM_LIMIT);
    QuerySnapshot queryRes = await PauloniaDocumentService.runQuery(query, cache);
    return getFromDocSnapList(queryRes.docs);
  }


  void addListener(Function(List<Id>) listener){
    _repositoryStream.stream.listen(listener);
  }

  void _update(List<Id> updatedIds){
    _repositoryStream.add(updatedIds);
  }



  CollectionReference _collectionReference;

  final StreamController<List<Id>> _repositoryStream = StreamController<List<Id>>.broadcast();

}