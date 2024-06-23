import 'package:easypos/pages/store/controller/store_data_controller.dart';
import 'package:easypos/pages/store/screens/billing/controller/billing_data_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoreLogout {

  Future<bool>logout({required BuildContext context}) async{
    
    context.read<BillingDataController>().dispose();
    context.read<StoreDataController>().emptyfy();

    return true;
  }
}