import 'package:dartz/dartz.dart';
import 'package:easypos/core/failure.dart';
import 'package:easypos/core/success.dart';
import 'package:easypos/models/store_model.dart';

abstract class StoreRepo {
  String getStoreIdForNewStore();

  Future<Either<DataCRUDFailure, Success>> createNewOrUpdateStore({required StoreModel store});

  Future<Either<DataCRUDFailure, Success>> deleteStore({required String storeId});

  Future<Either<DataCRUDFailure, StoreModel>> fetchStore({required String storeId});

  Either<DataCRUDFailure, Stream<List<StoreModel>>> fetchAllStoresOfUser();
}