import 'package:easypos/models/bill_model.dart';
import 'package:easypos/pages/store/screens/billing/screen/calculator_billing/layout/calculator_billing_mobile_layout.dart';
import 'package:easypos/pages/store/screens/billing/screen/calculator_billing/layout/calculator_billing_tablet_layout.dart';
import 'package:flutter/material.dart';

class CalculatorBillingLayout extends StatelessWidget {
  final BillModel bill;
  const CalculatorBillingLayout({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if(constraints.maxWidth <= 600) {
          return CalculatorBillingMobileLayout(bill: bill);
        } else {
          return CalculatorBillingTabletLayout(bill: bill,);
        }
      },
    );
  }
}