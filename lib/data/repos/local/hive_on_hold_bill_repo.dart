import 'package:dartz/dartz.dart';
import 'package:easypos/core/failure.dart';
import 'package:easypos/core/success.dart';
import 'package:easypos/models/bill_model.dart';

abstract class HiveOnHoldBillRepo {

  Stream<List<BillModel>> get onHoldBillStream;
  
  Future<Either<DataCRUDFailure, Success>> addUpdateBill({required BillModel bill});

  Future<Either<DataCRUDFailure, Success>> deleteBill({required String billId});
}