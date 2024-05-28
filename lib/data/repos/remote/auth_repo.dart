
import 'package:dartz/dartz.dart';
import 'package:easypos/core/failure.dart';
import 'package:easypos/core/success.dart';
import 'package:easypos/models/auth_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class RemoteAuthRepo {
  bool isSignedIn();
  Stream<User?> get user;

  User? get currentUser;
  
  Future<Either<DataCRUDFailure, Success>>signUp({required AuthModel authModel});

  Future<Either<DataCRUDFailure, Success>>signIn({required AuthModel authModel});

  Future<Either<DataCRUDFailure, Success>>signOut({required AuthModel authModel});

  Future<Either<DataCRUDFailure, Success>>setNewUserInfo({required UserCredential firebaseUserCredential});
}