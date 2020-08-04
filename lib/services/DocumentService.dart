import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_project_template/utils/utils.dart';

class DocumentService{

  static Future<DocumentSnapshot> getDoc(
      DocumentReference docRef, bool cache, {bool forceServer = false}) async{
    try{
      if(Utils.isOnTest()) return docRef.get();
      Source source = Source.serverAndCache;
      bool networkFlag = await Utils.checkNetwork();
      if(cache || !networkFlag){
        if(forceServer && !cache) return null;
        source = Source.cache;
      }
      return await docRef.get(source: source);
    }
    catch(error){
      if(error.runtimeType == PlatformException) return getDoc(docRef, false);
      ErrorService.sendError(error);
      return null;
    }
  }

  static Future<QuerySnapshot> getAll(
      CollectionReference collRef, bool cache, {bool forceServer = false}) async{
    try {
      if (Utils.isOnTest()) return collRef.getDocuments();
      Source source = Source.serverAndCache;
      bool networkFlag = await Utils.checkNetwork();
      if (cache || !networkFlag) {
        if (forceServer && !cache) return null;
        source = Source.cache;
      }
      return await collRef.getDocuments(source: source);
    }
    catch(error){
      if(error.runtimeType == PlatformException) return getAll(collRef, false);
      ErrorService.sendError(error);
      return null;
    }
  }

  static Future<QuerySnapshot> runQuery(Query query, bool cache, {bool forceServer = false}) async{
    try {
      if (Utils.isOnTest()) return query.getDocuments();
      Source source = Source.serverAndCache;
      bool networkFlag = await Utils.checkNetwork();
      if (cache || !networkFlag) {
        if (forceServer && !cache) return null;
        source = Source.cache;
      }
      return await query.getDocuments(source: source);
    }
    catch(error){
      if(error.runtimeType == PlatformException) return runQuery(query, false);
      ErrorService.sendError(error);
      return null;
    }
  }

  static Stream<QuerySnapshot> getStreamByQuery(Query query){
    return query.snapshots();
  }

}