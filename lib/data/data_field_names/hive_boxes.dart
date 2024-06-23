import 'package:easypos/models/bill_model.dart';
import 'package:hive/hive.dart';

class HiveBoxes {

  static const String _onHoldBillRepoBox = 'on-hold-bill-repo-box';

  static const String _processedBillRepoBox = 'processed-bill-repo-box';

  Future<Box<BillModel>> onHoldBillBox() async{
    return await Hive.openBox<BillModel>(_onHoldBillRepoBox);
  }

  Future<Box<BillModel>> processedBillBox() async{
    return await Hive.openBox<BillModel>(_onHoldBillRepoBox);
  }
}