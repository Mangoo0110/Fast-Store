import 'package:easypos/models/bill_model.dart';
import 'package:easypos/pages/store/screens/billing/screen/barcode_billing/barcode_billing_layout.dart';
import 'package:easypos/pages/store/screens/billing/screen/item_select_billing/item_select_billing_layout.dart';
import 'package:easypos/pages/store/screens/billing/widgets/billed_product_list_tablet_widget.dart';
import 'package:easypos/pages/store/screens/billing/widgets/select_product_items_widget.dart';
import 'package:easypos/utils/app_colors.dart';
import 'package:easypos/utils/app_textstyles.dart';
import 'package:easypos/utils/routing/smooth_page_transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CalculatorBillingTabletLayout extends StatefulWidget {
  final BillModel bill;
  const CalculatorBillingTabletLayout({super.key, required this.bill});

  @override
  State<CalculatorBillingTabletLayout> createState() => _CalculatorBillingTabletLayoutState();
}

class _CalculatorBillingTabletLayoutState extends State<CalculatorBillingTabletLayout> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text('Select Items', style: AppTextStyle().boldNormalSize(context: context),),
              actions: _actionBarOptionList(),
            ),
            body: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container( 
                      //height: 200,
                      width: constraints.maxWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: Colors.white,
                        boxShadow: const[
                          BoxShadow(color: Colors.black, blurRadius: 2)
                        ]
                      ),
                      child: BilledProductListTabletWidget(billId: widget.bill.billId)),
                  )),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SelectProductItemsWidget(billId: widget.bill.billId))),
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
            child: Icon(Icons.qr_code_scanner_sharp, color: Colors.black,),
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
              child: Icon(Icons.inventory_outlined, color: Colors.black,),
            )),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 2.0),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Color(0x1F000000), blurRadius: 5)
            ]
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                
              },
              child:  Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Icon(Icons.pause, color: Colors.black,),
                    Padding(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: Text('Hold', style: AppTextStyle().boldSmallSize(context: context),),
                    )
                  ],
                ),
              )),
          ),
        ),
      ),
    ];
  }

}