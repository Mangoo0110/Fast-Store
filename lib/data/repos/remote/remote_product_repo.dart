import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:easypos/core/failure.dart';
import 'package:easypos/core/success.dart';
import 'package:easypos/models/product_model.dart';

abstract class RemoteProductRepo {
  String getProductIdForNewProduct({required String storeId});
  Future<Either<DataCRUDFailure, Success>> createOrUpdateProduct({required ProductModel newProduct, required Uint8List? productImage, required String storeId});
  //Future<Either<Failure, ProductModel>> fetchAProduct({required ProductModel productId});
  Future<Either<DataCRUDFailure, Stream<List<ProductModel>>>> fetchAllProducts({required String storeId});

  Future<Either<DataCRUDFailure, Success>> deleteAProduct({required String productId, required String storeId});
}