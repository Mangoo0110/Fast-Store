import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:easypos/core/failure.dart';
import 'package:easypos/core/success.dart';
import 'package:easypos/data/datasources/firebase/firebase_image_repo_impl.dart';
import 'package:easypos/data/repos/remote/category_repo.dart';
import 'package:easypos/models/category_list_model.dart';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easypos/data/data_field_names/data_field_names.dart';
import 'package:easypos/data/datasources/firebase/firebase_auth_repo_impl.dart';
import 'package:easypos/utils/dekhao.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseCategoryRepoImpl extends RemoteCategoryRepo {

  final _userCollection = FirebaseFirestore.instance.collection(kfirestoreUserCollection);

  @override
  Future<Either<DataCRUDFailure, Success>> createNewCategory({required String categoryName, required Uint8List? categoryImage, required String storeId}) async{
    try {
      String userId = FirebaseAuthRepoImpl().currentUser!.uid;
      String imageId = FirebaseImageRepoImpl().newImageId();
      if(categoryImage != null) {
        return await FirebaseImageRepoImpl().uploadImage(imageBytes: categoryImage, imageId: imageId).then((uploadTask) => 
          uploadTask.fold(
            (failure) {
              return Left(failure);
            }, 
            (success) async{
              return await _userCollection
              .doc(userId).collection(kfirestoreStoreCollection)
              .doc(storeId).collection(kFirestoreCategoryListOfStoreCollection)
              .doc(storeId).set({kCategoryMap: {
                categoryName: imageId
              }}, SetOptions(merge: true)).then((value) => Right(Success(message: 'New category is created.')));
            }
          )
        );
      }else {
        return await _userCollection
        .doc(userId).collection(kfirestoreStoreCollection)
        .doc(storeId).collection(kFirestoreCategoryListOfStoreCollection)
        .doc(storeId).set({kCategoryMap: {
          categoryName: imageId
        }}, SetOptions(merge: true)).then((value) => Right(Success(message: 'New category is created.')));
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
  Future<Either<DataCRUDFailure, Stream<CategoryMapListModel>>> fetchAllCategories({required String storeId}) async{
    try {

      String userId = FirebaseAuthRepoImpl().currentUser!.uid;
      final Stream<DocumentSnapshot<Map<String, dynamic>>> firestoreAnswer =  _userCollection
      .doc(userId).collection(kfirestoreStoreCollection)
      .doc(storeId).collection(kFirestoreCategoryListOfStoreCollection)
      .doc(storeId).snapshots();
      Stream<CategoryMapListModel> categoryMapListOfStoreStream = firestoreAnswer.map((docSnap) {
        return CategoryMapListModel.fromMap(map: docSnap.data()!);
      });
      return Right(categoryMapListOfStoreStream);
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
