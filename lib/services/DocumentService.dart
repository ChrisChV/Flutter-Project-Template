import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_project_template/utils/utils.dart';

class DocumentService{

  static Future<DocumentSnapshot> getDoc(
      DocumentReference docRef, bool cache, {bool forceServer = false}) async{
    Source source = Source.serverAndCache;
    bool networkFlag = await Utils.checkNetwork();
    if(cache || !networkFlag){
      if(forceServer && !cache) return null;
      source = Source.cache;
    }
    return await docRef.get(source: source);
  }

  static Future<QuerySnapshot> getAll(
      CollectionReference collRef, bool cache, {bool forceServer = false}) async{
    Source source = Source.serverAndCache;
    bool networkFlag = await Utils.checkNetwork();
    if(cache || !networkFlag){
      if(forceServer && !cache) return null;
      source = Source.cache;
    }
    return await collRef.getDocuments(source: source);
  }

  static Future<QuerySnapshot> runQuery(Query query, bool cache, {bool forceServer = false}) async{
    Source source = Source.serverAndCache;
    bool networkFlag = await Utils.checkNetwork();
    if(cache || !networkFlag){
      if(forceServer && !cache) return null;
      source = Source.cache;
    }
    return await query.getDocuments(source: source);
  }

  static Stream<QuerySnapshot> getStreamByQuery(Query query){
    return query.snapshots();
  }

}