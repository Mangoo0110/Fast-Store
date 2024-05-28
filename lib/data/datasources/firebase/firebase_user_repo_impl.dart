import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:easypos/core/failure.dart';
import 'package:easypos/core/success.dart';
import 'package:easypos/data/data_field_names/data_field_names.dart';
import 'package:easypos/data/datasources/firebase/firebase_auth_repo_impl.dart';
import 'package:easypos/data/repos/remote/user_repo.dart';
import 'package:easypos/models/user_model.dart';
import 'package:easypos/utils/dekhao.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseUserRepoImpl extends RemoteUserRepo {

  final _userCollection = FirebaseFirestore.instance.collection(kfirestoreUserCollection);

  @override
  Future<Either<DataCRUDFailure, UserModel>> fetchCurrentUserInfo() async{
    try {
      String userId = FirebaseAuthRepoImpl().currentUser!.uid;
      dekhao("FirebaseAuthRepoImpl().currentUser!.uid $userId");
      return await _userCollection.doc(userId).get()
      .then((docSnap) {
        if(docSnap.data() == null) {
          return Left(DataCRUDFailure(failure: Failure.noData, message: 'Data not found!'));
        } else{
          return Right(UserModel.fromMap(map: docSnap.data()!));
        }
      });

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
  Future<Either<DataCRUDFailure, Success>> updateCurrentUserInfo({required UserModel updatedInfo}) async{
    try {
      String userId = FirebaseAuthRepoImpl().currentUser!.uid;
      return await _userCollection.doc(userId).update(updatedInfo.toMap()).then((value) => Right(Success(message: 'User info is updated.')));

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