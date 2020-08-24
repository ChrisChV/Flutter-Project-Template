import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project_template/services/ErrorService.dart';
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
      docRef.get(GetOptions(source: source));
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
      if (Utils.isOnTest()) return collRef.get();
      Source source = Source.serverAndCache;
      bool networkFlag = await Utils.checkNetwork();
      if (cache || !networkFlag) {
        if (forceServer && !cache) return null;
        source = Source.cache;
      }
      return await collRef.get(GetOptions(source: source));
    }
    catch(error){
      if(error.runtimeType == PlatformException) return getAll(collRef, false);
      ErrorService.sendError(error);
      return null;
    }
  }

  static Future<QuerySnapshot> runQuery(Query query, bool cache, {bool forceServer = false}) async{
    try {
      if (Utils.isOnTest()) return query.get();
      Source source = Source.serverAndCache;
      bool networkFlag = await Utils.checkNetwork();
      if (cache || !networkFlag) {
        if (forceServer && !cache) return null;
        source = Source.cache;
      }
      return await query.get(GetOptions(source: source));
    }
    catch(error){
      if(error.runtimeType == PlatformException) return runQuery(query, false);
      ErrorService.sendError(error);
      return null;
    }
  }

  static Stream<QuerySnapshot> getStreamByQuery(Query query){
    QuerySnapshot querySnapshot;
    return query.snapshots();
  }

}