import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:easypos/core/failure.dart';
import 'package:easypos/core/success.dart';
import 'package:easypos/models/bill_model.dart';

abstract class RemoteBillRepo {
  String newBillId({required String storeId});

  Future<Either<DataCRUDFailure, Success>> deleteBill({required String billId, required String storeId});

  Future<Either<DataCRUDFailure, Success>> uploadBill({required BillModel bill, required String storeId});

  Either<DataCRUDFailure, Stream<List<BillModel>>> fetchOnHoldBillList({required String storeId});

  Either<DataCRUDFailure, Stream<List<BillModel>>> fetchPaidBillListInTimeRange({required String storeId, required Timestamp fromTime, required Timestamp toTime});

  Either<DataCRUDFailure, Stream<List<BillModel>>> fetchOrderBillListInTimeRange({required String storeId, required Timestamp fromTime, required Timestamp toTime});
  
  Either<DataCRUDFailure, Stream<List<BillModel>>> fetchBillListInTimeRange({required String storeId, required Timestamp fromTime, required Timestamp toTime});

  Future<Either<DataCRUDFailure, List<BillModel>>> fetchBillListOfCustomerByContactNoInTimeRange({required String storeId, required String contactNo, required Timestamp fromTime, required Timestamp toTime});

  Future<Either<DataCRUDFailure, List<BillModel>>> fetchBillListOfCustomerByNameInTimeRange({required String storeId, required String customerName, required Timestamp fromTime, required Timestamp toTime});
}