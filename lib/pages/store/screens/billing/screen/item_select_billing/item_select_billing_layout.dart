import 'package:easypos/models/bill_model.dart';
import 'package:easypos/pages/store/screens/billing/screen/item_select_billing/layout/item_select_billing_mobile_layout.dart';
import 'package:easypos/pages/store/screens/billing/screen/item_select_billing/layout/item_select_billing_tablet_layout.dart';
import 'package:flutter/material.dart';

class ItemSelectBillingLayout extends StatelessWidget {
  final BillModel bill;
  const ItemSelectBillingLayout({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if(constraints.maxWidth <= 600) {
          return ItemSelectBillingMobileLayout(bill: bill);
        } else {
          return ItemSelectBillingTabletLayout(bill: bill,);
        }
      },
    );
  }
}