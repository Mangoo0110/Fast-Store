import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:easypos/core/failure.dart';
import 'package:easypos/core/success.dart';
import 'package:easypos/data/data_field_names/data_field_names.dart';
import 'package:easypos/data/datasources/firebase/firebase_auth_repo_impl.dart';
import 'package:easypos/data/repos/remote/remote_bill_repo.dart';
import 'package:easypos/models/bill_model.dart';
import 'package:easypos/models/billing_product.dart';
import 'package:easypos/utils/dekhao.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseStoreBillingRepoImpl extends RemoteStoreBillRepo {

  final _userCollection = FirebaseFirestore.instance.collection(kfirestoreUserCollection);

  CollectionReference<Map<String, dynamic>> _billingCollectionReference({required String userId, required String storeId}) {
    return _userCollection.doc(userId).collection(kfirestoreStoreCollection).doc(storeId).collection(kFirestoreBillingCollection);
  }

  CollectionReference<Map<String, dynamic>> _productCollectionReference({required String userId, required String storeId}) {
    return _userCollection.doc(userId).collection(kfirestoreStoreCollection).doc(storeId).collection(kFirestoreStoreProductCollection);
  }

  @override
  String newBillId({required String storeId}) {
    String userId = FirebaseAuthRepoImpl().currentUser!.uid;
    return _userCollection.doc(storeId).collection('$kfirestoreUserCollection/{$userId}/$kfirestoreStoreCollection/{$storeId}/$kFirestoreBillingCollection').doc().id;
  }

  @override
  Future<Either<DataCRUDFailure, Success>> deleteBill({required String billId, required String storeId}) async{
    try {

      String userId = FirebaseAuthRepoImpl().currentUser!.uid;
      await _productCollectionReference(userId: userId, storeId: storeId).doc(billId).delete();
      return Right(Success(message: 'Bill is deleted.'));

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
  Future<Either<DataCRUDFailure, Success>> createOrUpdateBill({required BillModel newBill, required String storeId}) async{
    try {

      String userId = FirebaseAuthRepoImpl().currentUser!.uid;
      WriteBatch batch = FirebaseFirestore.instance.batch();
      newBill.idMappedBilledProductList.entries.map((mapEntry) {
        final BillingProduct billingProduct = mapEntry.value;
        batch.update(
          _productCollectionReference(userId: userId, storeId: storeId)
          .doc(billingProduct.productId), 
          {
            kquantityMapFrequency: {
              billingProduct.quantity: FieldValue.increment(1),
            }
          }
        );
      });

      batch.set(_billingCollectionReference(userId: userId, storeId: storeId).doc(newBill.billId), newBill.toMap());

      return await batch.commit().then((value) {
        return Right(Success(message: 'Bill is uploaded.'));
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
  Either<DataCRUDFailure, Stream<List<BillModel>>> fetchDueBillListInTimeRange({
    required String storeId, required Timestamp fromTime, required Timestamp toTime
  }) {
    try {

      String userId = FirebaseAuthRepoImpl().currentUser!.uid;
      return Right(_productCollectionReference(userId: userId, storeId: storeId)
      .where(kdueAmount, isGreaterThan: 0)
      .where(kbilledAt, isLessThanOrEqualTo: toTime, isGreaterThanOrEqualTo: fromTime)
      .snapshots().map((querySnapshot) {
        return querySnapshot.docs
            .map((qsnap) {
              // dekhao(qsnap.data().toString());
              BillModel product = BillModel.fromMap(map: qsnap.data());
              // dekhao(product.toMap());
              return product;
            })
            .toList();
      }));

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
  Either<DataCRUDFailure, Stream<List<BillModel>>> fetchOrderBillListInTimeRange({required String storeId, required Timestamp fromTime, required Timestamp toTime}) {
    try {

      String userId = FirebaseAuthRepoImpl().currentUser!.uid;
      return Right(_productCollectionReference(userId: userId, storeId: storeId)
      .where(kbillType, isEqualTo: BillType.storeOrder)
      .where(kbilledAt, isLessThanOrEqualTo: toTime, isGreaterThanOrEqualTo: fromTime)
      .snapshots().map((querySnapshot) {
        return querySnapshot.docs
            .map((qsnap) {
              // dekhao(qsnap.data().toString());
              BillModel product = BillModel.fromMap(map: qsnap.data());
              // dekhao(product.toMap());
              return product;
            })
            .toList();
      }));

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
  Either<DataCRUDFailure, Stream<List<BillModel>>> fetchPaidBillListInTimeRange({required String storeId, required Timestamp fromTime, required Timestamp toTime}) {
    try {

      String userId = FirebaseAuthRepoImpl().currentUser!.uid;
      return Right(_productCollectionReference(userId: userId, storeId: storeId)
      .where(kdueAmount, isEqualTo: 0)
      .where(kbilledAt, isLessThanOrEqualTo: toTime, isGreaterThanOrEqualTo: fromTime)
      .snapshots().map((querySnapshot) {
        return querySnapshot.docs
            .map((qsnap) {
              // dekhao(qsnap.data().toString());
              BillModel product = BillModel.fromMap(map: qsnap.data());
              // dekhao(product.toMap());
              return product;
            })
            .toList();
      }));

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
  Future<Either<DataCRUDFailure, List<BillModel>>> fetchBillListOfCustomerByContactNoInTimeRange({required String storeId, required String contactNo, required Timestamp fromTime, required Timestamp toTime}) async{
    try {

      String userId = FirebaseAuthRepoImpl().currentUser!.uid;
      return Right(await _productCollectionReference(userId: userId, storeId: storeId)
      .where(kcustomerContactNo, isEqualTo: contactNo)
      .where(kbilledAt, isLessThanOrEqualTo: toTime, isGreaterThanOrEqualTo: fromTime)
      .get().then((querySnapshot) {
        return querySnapshot.docs
            .map((qsnap) {
              // dekhao(qsnap.data().toString());
              BillModel product = BillModel.fromMap(map: qsnap.data());
              // dekhao(product.toMap());
              return product;
            })
            .toList();
      }));

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
  Future<Either<DataCRUDFailure, List<BillModel>>> fetchBillListOfCustomerByNameInTimeRange({required String storeId, required String customerName, required Timestamp fromTime, required Timestamp toTime}) async{
    try {

      String userId = FirebaseAuthRepoImpl().currentUser!.uid;
      return Right(await _productCollectionReference(userId: userId, storeId: storeId)
      .where(kcustomerName, isEqualTo: customerName)
      .where(kbilledAt, isLessThanOrEqualTo: toTime, isGreaterThanOrEqualTo: fromTime)
      .get().then((querySnapshot) {
        return querySnapshot.docs
            .map((qsnap) {
              // dekhao(qsnap.data().toString());
              BillModel product = BillModel.fromMap(map: qsnap.data());
              // dekhao(product.toMap());
              return product;
            })
            .toList();
      }));

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