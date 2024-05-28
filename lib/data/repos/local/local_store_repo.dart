import 'package:dartz/dartz.dart';
import 'package:easypos/core/failure.dart';
import 'package:easypos/core/success.dart';
import 'package:easypos/models/store_model.dart';

abstract class LocalStoreRepo {

  Future<Either<DataCRUDFailure, StoreModel?>> currentStoreInfo();

  Future<Either<DataCRUDFailure, Success>> setCurrentStoreInfo({required StoreModel store});

  Future<Either<DataCRUDFailure, Success>> currentStoreLogout();

}