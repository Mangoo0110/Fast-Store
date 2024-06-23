import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:easypos/core/failure.dart';
import 'package:easypos/core/success.dart';
import 'package:easypos/data/repos/local/hive_on_hold_bill_repo.dart';
import 'package:easypos/data/repos/local/hive_processed_bill_repo.dart';
import 'package:easypos/models/bill_model.dart';
import 'package:easypos/utils/dekhao.dart';
import 'package:hive/hive.dart';

class HiveProcessedBillRepoImpl extends HiveProcessedBillRepo{  

  final StreamController<List<BillModel>> streamController;
  final Box<BillModel> box;

  HiveProcessedBillRepoImpl({required this.streamController, required this.box}) {

    streamController.add(box.values.toList());
    box.watch().listen((event) {
      streamController.add(box.values.toList());
    });
    
  }

  dispose() {
    streamController.close();
  }

  @override
  Stream<List<BillModel>> get processedBillStream => streamController.stream;

  @override
  Future<Either<DataCRUDFailure, Success>> addUpdateBill({required BillModel bill}) async {
    try {
      
      if(box.keys.length > 1000) {
        await deleteBill(billId: box.keys.first);
      }
      await box.put(bill.billId, bill);
      return Right(Success(message: 'Stored locally'));

    } on OutOfMemoryError{
      return Left(DataCRUDFailure(failure: Failure.outOfMemoryError, message: " Out of storage"));
    } catch (e) {
      dekhao("local error");
      dekhao(e.toString());
      return Left(DataCRUDFailure(failure: Failure.unknownFailure, message: e.toString()));
    }
  }

  @override
  Future<Either<DataCRUDFailure, Success>> deleteBill({required String billId}) async {
    
    try {
      return await box.delete(id).then((value) {
        return Right(Success(message: 'Deleted'));
      });
      
    } on OutOfMemoryError{
      return Left(DataCRUDFailure(failure: Failure.outOfMemoryError, message: "Failed!"));
    }catch (e) {
      dekhao("local error");
      dekhao(e.toString());
      return Left(DataCRUDFailure(failure: Failure.unknownFailure, message: e.toString()));
    }
  }

  

}