import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:easypos/core/failure.dart';
import 'package:easypos/core/success.dart';
import 'package:easypos/data/repos/local/local_user_repo.dart';
import 'package:easypos/models/user_model.dart';
import 'package:easypos/utils/dekhao.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

class HiveUserRepoImpl extends LocalUserRepo {

  static const String _userRepoKey = 'anikMadeUserInfoKey';
  static const String _userRepoBox = 'user-repo-box';


  Future<Box?> _openBox() async{
    Box? storeRepoBox;
    await Hive.openBox(_userRepoBox).then((box) => storeRepoBox = box);
    return storeRepoBox;
  }
  


  @override
  Future<Either<DataCRUDFailure, UserModel?>> fetchCurrentUserInfo() async{
    try {
      Box? userRepoBox = await _openBox();
      if(userRepoBox != null) {
        dynamic userRawData = userRepoBox.get(_userRepoKey);
        if(userRawData == null) {
          return const Right(null);
        } else {
          return Right(UserModel.fromMap(map: userRawData as Map<String, dynamic>)) ;
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
  Future<Either<DataCRUDFailure, Success>> storeUserInfo({required UserModel user}) async{
    try {
      Box? userRepoBox = await _openBox();
      if(userRepoBox != null) {
        return await userRepoBox.put(_userRepoKey, user.toMap()).then((value) => Right(Success(message: "User catched.")));
        
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
  Future<Either<DataCRUDFailure, Success>> userLogout() async{
    try {
      Box? userRepoBox = await _openBox();
      if(userRepoBox != null) {
        return await userRepoBox.delete(_userRepoKey).then((value) => Right(Success(message: "User catche deleted.")));
        
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