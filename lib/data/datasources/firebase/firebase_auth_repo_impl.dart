import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:easypos/core/failure.dart';
import 'package:easypos/core/success.dart';
import 'package:easypos/data/data_field_names/data_field_names.dart';
import 'package:easypos/data/datasources/firebase/firebase_image_repo_impl.dart';
import 'package:easypos/data/repos/remote/auth_repo.dart';
import 'package:easypos/models/auth_model.dart';
import 'package:easypos/models/user_model.dart';
import 'package:easypos/utils/dekhao.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthRepoImpl extends  RemoteAuthRepo{

  final FirebaseAuth _authInstance;
  final _userCollection = FirebaseFirestore.instance.collection(kfirestoreUserCollection);

  FirebaseAuthRepoImpl({FirebaseAuth? authInstance}) : _authInstance = authInstance ?? FirebaseAuth.instance;

  @override
  Stream<User?> get user {
    return _authInstance.authStateChanges().map((firebaseUser) {
      return firebaseUser;
    });
  }

  @override
  bool isSignedIn() {
    if(_authInstance.currentUser == null){
       return false; 
    }
    return true;
  }
  
  

  @override
  Future<Either<DataCRUDFailure, Success>> signOut({
    required AuthModel authModel
  }) async{
    try {
      await _authInstance.signOut();
      if(isSignedIn()) return Left(DataCRUDFailure(failure: Failure.authFailure, message: ''));
      return Right(Success());
    } on SocketException {
      return Left(DataCRUDFailure(failure: Failure.socketFailure, message: 'Internet connection failed!'));
    } on FirebaseAuthException catch(e){
      return Left(DataCRUDFailure(failure: Failure.authFailure, message: e.code));
    }
     catch (e) {
      dekhao("signIn remote error");
      dekhao(e.toString());
    }
    return Left(DataCRUDFailure(failure: Failure.authFailure, message: ''));
  }
  
  @override
  Future<Either<DataCRUDFailure, Success>> signUp({
    required AuthModel authModel
  }) async {
    try {
      final UserCredential credential = await _authInstance.createUserWithEmailAndPassword(
        email: authModel.email, 
        password: authModel.password
      );
      if(credential.user == null) {

        return Left(DataCRUDFailure(failure: Failure.authFailure, message: ''));

      } else {

        final result = await setNewUserInfo(firebaseUserCredential: credential);
        return result.fold(
          (dataCRUDFailure) {
            return Left(dataCRUDFailure);
          }, 
          (success) {
            return Right(success);
          });

      }
    } on SocketException {
      return Left(DataCRUDFailure(failure: Failure.authFailure, message: ''));
    }
     catch (e) {
      return Left(DataCRUDFailure(failure: Failure.authFailure, message: e.toString()));
    }
  }

  @override
  Future<Either<DataCRUDFailure, Success>> signIn({
    required AuthModel authModel
  }) async {
    try {
      final UserCredential credential = await _authInstance.signInWithEmailAndPassword(
        email: authModel.email, 
        password: authModel.password
      );
      if(credential.user == null) return Left(DataCRUDFailure(failure: Failure.authFailure, message: ''));
      return Right(Success());
    } on SocketException {
      return Left(DataCRUDFailure(failure: Failure.socketFailure, message: ''));
    } on FirebaseAuthException catch(e){
      return Left(DataCRUDFailure(failure: Failure.firebaseFailure, message: e.code));
    }
     catch (e) {
      return Left(DataCRUDFailure(failure: Failure.authFailure, message: e.toString()));
    }
  }
  
  @override
  Future<Either<DataCRUDFailure, Success>> setNewUserInfo({required UserCredential firebaseUserCredential}) async{
    try {
      UserModel newUser = UserModel(
        userId: firebaseUserCredential.user!.uid, 
        userImageId: FirebaseImageRepoImpl().newImageId(), 
        email: firebaseUserCredential.user!.email!, 
        fullName: firebaseUserCredential.user!.email!, 
        contactNo: ''
      );
      await _userCollection.doc(firebaseUserCredential.user!.uid).set(newUser.toMap());
      return Right(Success());
    } on SocketException {
      return Left(DataCRUDFailure(failure: Failure.socketFailure, message: 'Poor internet connection. Failed to set the user.'));
    } on FirebaseAuthException catch(e){
      return Left(DataCRUDFailure(failure: Failure.firebaseFailure, message: e.code));
    } on FirebaseException catch(e) {
      return Left(DataCRUDFailure(failure: Failure.firebaseFailure, message: e.code));
    }
    catch (e) {
      return Left(DataCRUDFailure(failure: Failure.unknownFailure, message: 'Failure: Internal error.'));
    }
  }
  
  @override
  // TODO: implement currentUser
  User? get currentUser => _authInstance.currentUser;
  
}