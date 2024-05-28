import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:easypos/core/failure.dart';
import 'package:easypos/core/success.dart';
import 'package:easypos/models/category_list_model.dart';

abstract class RemoteCategoryRepo {
  Future<Either<DataCRUDFailure, Success>> createNewCategory({required String categoryName, required Uint8List? categoryImage, required String storeId});

  Future<Either<DataCRUDFailure, Stream<CategoryMapListModel>>>  fetchAllCategories({required String storeId});
  //Future<Either<Failure, Success>> deleteACategory({required String categoryName, required String storeId});
}