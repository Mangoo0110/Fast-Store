import 'package:dartz/dartz.dart';
import 'package:easypos/core/failure.dart';
import 'package:easypos/core/success.dart';
import 'package:easypos/models/user_model.dart';

abstract class RemoteUserRepo {
  Future<Either<DataCRUDFailure, UserModel>> fetchCurrentUserInfo();

  Future<Either<DataCRUDFailure, Success>> updateCurrentUserInfo({required UserModel updatedInfo});

  
}