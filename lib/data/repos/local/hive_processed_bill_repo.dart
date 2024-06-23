import 'package:dartz/dartz.dart';
import 'package:easypos/core/failure.dart';
import 'package:easypos/core/success.dart';
import 'package:easypos/models/bill_model.dart';

abstract class HiveProcessedBillRepo {

  Stream<List<BillModel>> get processedBillStream;
  
  Future<Either<DataCRUDFailure, Success>> addUpdateBill({required BillModel bill});

  Future<Either<DataCRUDFailure, Success>> deleteBill({required String billId});
}