import 'package:easypos/models/bill_model.dart';
import 'package:easypos/pages/store/screens/billing/screen/barcode_billing/barcode_billing_layout.dart';
import 'package:easypos/pages/store/screens/billing/screen/item_select_billing/item_select_billing_layout.dart';
import 'package:easypos/pages/store/screens/billing/widgets/calculator_widget.dart';
import 'package:easypos/pages/store/screens/billing/widgets/select_product_items_widget.dart';
import 'package:easypos/pages/store/screens/billing/widgets/short_overview_of_bill_widget.dart';
import 'package:easypos/utils/app_colors.dart';
import 'package:easypos/utils/app_sizes.dart';
import 'package:easypos/utils/app_textstyles.dart';
import 'package:easypos/utils/routing/smooth_page_transition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CalculatorBillingMobileLayout extends StatefulWidget {
  final BillModel bill;
  const CalculatorBillingMobileLayout({super.key, required this.bill});

  @override
  State<CalculatorBillingMobileLayout> createState() => _CalculatorBillingMobileLayoutState();
}

class _CalculatorBillingMobileLayoutState extends State<CalculatorBillingMobileLayout> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: AppColors().appActionColor(context: context),
              title: Text('Select Items', style: TextStyle(color: Colors.white, fontSize: AppSizes().normalText, fontWeight: FontWeight.bold),),
              actions: _actionBarOptionList(),
            ),
            body: Column(
              //mainAxisSize: MainAxisSize.max,
              children: [
                
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CalculatorWidget(billId: widget.bill.billId,),
                  ),
                ),
                Container( 
                  height: 120,
                  width: constraints.maxWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Colors.white,
                    boxShadow: const[
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 3
                      )
                    ]
                    //color: AppColors().grey(),
                  ),
                  child: ShortOverviewOfBillWidget(billId: widget.bill.billId)),
              ],
            ),
          ),
        );
      },
    );
  }
  List<Widget> _actionBarOptionList(){
    return [
      Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            Navigator.of(context).pushReplacement(SmoothPageTransition().createRoute(secondScreen: BarcodeBillingLayout(bill: widget.bill)));
          },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.qr_code_scanner_sharp, color: Colors.white,),
          )),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 2.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              Navigator.of(context).pushReplacement(SmoothPageTransition().createRoute(secondScreen: ItemSelectBillingLayout(bill: widget.bill)));
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.inventory_outlined, color: Colors.white,),
            )),
        ),
      ),
      
    ];
  }

}