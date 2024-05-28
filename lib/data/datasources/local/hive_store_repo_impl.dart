import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:easypos/core/failure.dart';
import 'package:easypos/core/success.dart';
import 'package:easypos/data/repos/local/local_store_repo.dart';
import 'package:easypos/models/store_model.dart';
import 'package:easypos/utils/dekhao.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

class HiveStoreRepoImpl extends LocalStoreRepo {

  static const String _storeRepoKey = 'anikMadeStoreInfoKey';
  static const String _storeRepoBox = 'store-repo-box';


  Future<Box?> _openBox() async{
    Box? storeRepoBox;
    await Hive.openBox(_storeRepoBox).then((box) => storeRepoBox = box);
    return storeRepoBox;
  }
  

  @override
  Future<Either<DataCRUDFailure, Success>> currentStoreLogout()async {
    try {
      Box? storeRepoBox = await _openBox();
      if(storeRepoBox != null) {
        return await storeRepoBox.delete(_storeRepoKey).then((value) => Right(Success(message: "Store catche deleted.")));
        
      } else {
        return Left(DataCRUDFailure(failure: Failure.severFailure, message: 'Local storage problem.'));
      }

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
  Future<Either<DataCRUDFailure, StoreModel?>> currentStoreInfo() async{
    try {
      Box? storeRepoBox = await _openBox();
      if(storeRepoBox != null) {
        dynamic storeRawData = storeRepoBox.get(_storeRepoKey);
        if(storeRawData == null) {
          return const Right(null);
        } else {
          return Right(StoreModel.fromMap(map: storeRawData as Map<String, dynamic>)) ;
        }
      } else {
        return const Right(null);
      }

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
  Future<Either<DataCRUDFailure, Success>> setCurrentStoreInfo({required StoreModel store}) async{
    try {
      Box? storeRepoBox = await _openBox();
      if(storeRepoBox != null) {
        return await storeRepoBox.put(_storeRepoKey, store.toMap()).then((value) => Right(Success(message: "Store catched.")));
        
      } else {
        return Left(DataCRUDFailure(failure: Failure.severFailure, message: 'Local storage problem.'));
      }

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