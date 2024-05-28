import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:easypos/core/failure.dart';
import 'package:easypos/core/success.dart';
import 'package:flutter/foundation.dart';

abstract class ImageRepo {
  String newImageId();

  Future<Either<DataCRUDFailure, Uint8List?>> fetchImage({required String imageId});

  Future<Either<DataCRUDFailure, String>> uploadImage({required Uint8List imageBytes, required String imageId});

  Future<Either<DataCRUDFailure, Success>> deleteImage({required String imageId});
  
}