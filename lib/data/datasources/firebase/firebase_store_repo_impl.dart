import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:easypos/core/failure.dart';
import 'package:easypos/core/success.dart';
import 'package:easypos/data/data_field_names/data_field_names.dart';
import 'package:easypos/data/datasources/firebase/firebase_auth_repo_impl.dart';
import 'package:easypos/data/repos/remote/store_repo.dart';
import 'package:easypos/models/store_model.dart';
import 'package:easypos/utils/dekhao.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RemoteStoreDataSourceImpl extends StoreRepo {

  final CollectionReference<Map<String, dynamic>>  _userCollection = FirebaseFirestore.instance.collection(kfirestoreUserCollection); 


  @override
  String getStoreIdForNewStore() {
    String userId = FirebaseAuthRepoImpl().currentUser!.uid;
    return _userCollection.doc(userId).collection(kfirestoreStoreCollection).doc().id;
  } 

  @override
  Future<Either<DataCRUDFailure, Success>> createNewOrUpdateStore({required StoreModel store}) async{
    try {
      String userId = FirebaseAuthRepoImpl().currentUser!.uid;
      await _userCollection.doc(userId).collection(kfirestoreStoreCollection).doc(store.storeId).set(store.toMap());
      return Right(Success(message: 'Store is created/updated'));

    } on SocketException {
      return Left(DataCRUDFailure(failure: Failure.socketFailure, message: 'Internet connection failed!'));
    } on FirebaseAuthException catch(e){
      return Left(DataCRUDFailure(failure: Failure.authFailure, message: e.code));
    } catch (e) {
      dekhao("remote error");
      dekhao(e.toString());
      return Left(DataCRUDFailure(failure: Failure.unknownFailure, message: e.toString()));
    }
  }

  @override
  Future<Either<DataCRUDFailure, Success>> deleteStore({required String storeId})async {
    try {
      String userId = FirebaseAuthRepoImpl().currentUser!.uid;
      await _userCollection.doc(userId).collection(kfirestoreStoreCollection).doc(storeId).delete();
      return Right(Success(message: 'Store is deleted'));

    } on SocketException {
      return Left(DataCRUDFailure(failure: Failure.socketFailure, message: 'Internet connection failed!'));
    } on FirebaseAuthException catch(e){
      return Left(DataCRUDFailure(failure: Failure.authFailure, message: e.code));
    } catch (e) {
      dekhao("remote error");
      dekhao(e.toString());
      return Left(DataCRUDFailure(failure: Failure.unknownFailure, message: e.toString()));
    }
  }

  @override
  Future<Either<DataCRUDFailure, StoreModel>> fetchStore({required String storeId}) async{
    try {
      String userId = FirebaseAuthRepoImpl().currentUser!.uid;
      final DocumentSnapshot<Map<String, dynamic>> result = await _userCollection.doc(userId).collection(kfirestoreStoreCollection).doc(storeId).get();
      StoreModel store = StoreModel.fromMap(map: result.data()!); 
      return Right(store);

    } on SocketException {
      return Left(DataCRUDFailure(failure: Failure.socketFailure, message: 'Internet connection failed!'));
    } on FirebaseAuthException catch(e){
      return Left(DataCRUDFailure(failure: Failure.authFailure, message: e.code));
    } catch (e) {
      dekhao("remote error");
      dekhao(e.toString());
      return Left(DataCRUDFailure(failure: Failure.unknownFailure, message: e.toString()));
    }
  }

  
  
  @override
  Either<DataCRUDFailure, Stream<List<StoreModel>>> fetchAllStoresOfUser() {
    try {
      String userId = FirebaseAuthRepoImpl().currentUser!.uid;
      final Stream<QuerySnapshot> result = _userCollection.doc(userId).collection(kfirestoreStoreCollection).snapshots();
      final Stream<List<StoreModel>> userStoresStream = result.map((querySnapshot) {
        return querySnapshot.docs
            .map((qsnap) {
              StoreModel store = StoreModel.fromMap(map: qsnap.data() as Map<String, dynamic>);
              dekhao(store.toMap());
              return store;
            })
            .toList();
      });

      return Right(userStoresStream);

    } on SocketException {
      return Left(DataCRUDFailure(failure: Failure.socketFailure, message: 'Internet connection failed!'));
    } on FirebaseAuthException catch(e){
      return Left(DataCRUDFailure(failure: Failure.authFailure, message: e.code));
    } catch (e) {
      dekhao("remote error");
      dekhao(e.toString());
      return Left(DataCRUDFailure(failure: Failure.unknownFailure, message: e.toString()));
    }
  }

}