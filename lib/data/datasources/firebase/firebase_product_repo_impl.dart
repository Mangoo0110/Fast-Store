import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:easypos/core/failure.dart';
import 'package:easypos/core/success.dart';
import 'package:easypos/data/data_field_names/data_field_names.dart';
import 'package:easypos/data/datasources/firebase/firebase_auth_repo_impl.dart';
import 'package:easypos/data/datasources/firebase/firebase_image_repo_impl.dart';
import 'package:easypos/data/repos/remote/remote_product_repo.dart';
import 'package:easypos/models/product_model.dart';
import 'package:easypos/utils/dekhao.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseProductRepoImpl extends RemoteProductRepo {

  final _userCollection = FirebaseFirestore.instance.collection(kfirestoreUserCollection);

  @override
  String getProductIdForNewProduct({required String storeId}) {
    String userId = FirebaseAuthRepoImpl().currentUser!.uid;
    return _userCollection
        .doc(userId).collection('$kfirestoreUserCollection/{$userId}/$kfirestoreStoreCollection')
        .doc().id;
  }

  @override
  Future<Either<DataCRUDFailure, Success>> createOrUpdateProduct({required ProductModel newProduct, required Uint8List? productImage, required String storeId}) async{
    try {
      String userId = FirebaseAuthRepoImpl().currentUser!.uid;
      if(productImage != null) {
        await FirebaseImageRepoImpl().uploadImage(imageBytes: productImage, imageId: newProduct.productImageId);
      }
      await _userCollection
      .doc(userId).collection(kfirestoreStoreCollection)
      .doc(storeId).collection(kFirestoreStoreProductCollection)
      .doc(newProduct.productId).set(newProduct.toMap());
      return Right(Success(message: 'Product is created/updated'));

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
  Future<Either<DataCRUDFailure, Success>> deleteAProduct({required String productId, required String storeId}) async{
    try {

      String userId = FirebaseAuthRepoImpl().currentUser!.uid;
      return await _userCollection
      .doc(userId).collection(kfirestoreStoreCollection)
      .doc(storeId).collection(kFirestoreStoreProductCollection)
      .doc(productId).delete()
      .then((value) => Right(Success(message: 'Product is created/updated')));

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
  Future<Either<DataCRUDFailure, Stream<List<ProductModel>>>> fetchAllProducts({required String storeId}) async{
    try {
      String userId = FirebaseAuthRepoImpl().currentUser!.uid;
      final firestoreAnswer = _userCollection
      .doc(userId).collection(kfirestoreStoreCollection)
      .doc(storeId).collection(kFirestoreStoreProductCollection)
      .snapshots();
      
      final Stream<List<ProductModel>> userStoreProductCollectionStream = firestoreAnswer.map((querySnapshot) {
        return querySnapshot.docs
            .map((qsnap) {
              // dekhao(qsnap.data().toString());
              ProductModel product = ProductModel.fromMap(map: qsnap.data());
              // dekhao(product.toMap());
              return product;
            })
            .toList();
      });
      return Right(userStoreProductCollectionStream);
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