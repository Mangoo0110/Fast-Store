import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:easypos/core/failure.dart';
import 'package:easypos/core/success.dart';
import 'package:easypos/data/data_field_names/data_field_names.dart';
import 'package:easypos/data/repos/remote/image_repo.dart';
import 'package:easypos/utils/dekhao.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseImageRepoImpl extends ImageRepo {

  final Reference  storageRef = FirebaseStorage.instance.ref();

  final FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;

  @override
  String newImageId() {
    return _firestoreInstance.collection(kFirestoreImageCollection).doc().id;
  }

  @override
  Future<Either<DataCRUDFailure, String>> uploadImage({required Uint8List imageBytes, required String imageId}) async{
    try {

      final TaskSnapshot result = await storageRef.child(imageId).putData(imageBytes);
      if(result.state == TaskState.success) {
        return Right(result.ref.fullPath);
      } else {
        return Left(DataCRUDFailure(failure: Failure.firebaseFailure, message: 'Could not upload image. Try uploading image in limit size'));
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
  Future<Either<DataCRUDFailure, Success>> deleteImage({required String imageId}) async{
    try {

      return await storageRef.child(imageId).delete().then((value) => Right(Success(message: 'Deleted')));

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
  Future<Either<DataCRUDFailure, Uint8List?>> fetchImage({required String imageId}) async{
    try {

      return await storageRef.child(imageId).getData().then((file) {
        if(file == null) {
          return Left(DataCRUDFailure(failure: Failure.noData, message: 'Not found'));
        } else {
          return Right(file);
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

}