import 'package:easypos/models/bill_model.dart';
import 'package:easypos/pages/store/screens/billing/screen/barcode_billing/layout/barcode_billing_mobile_layout.dart';
import 'package:easypos/pages/store/screens/billing/screen/barcode_billing/layout/barcode_billing_tablet_layout.dart';
import 'package:flutter/material.dart';

class BarcodeBillingLayout extends StatelessWidget {
  final BillModel bill;
  const BarcodeBillingLayout({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if(constraints.maxWidth <= 600) {
          return BarcodeBillingMobileLayout(bill: bill);
        } else {
          return BarcodeBillingTabletLayout(bill: bill,);
        }
      },
    );
  }
}