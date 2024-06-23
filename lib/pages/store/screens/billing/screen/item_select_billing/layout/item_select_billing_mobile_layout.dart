import 'package:easypos/models/bill_model.dart';
import 'package:easypos/pages/store/screens/billing/controller/billing_data_controller.dart';
import 'package:easypos/pages/store/screens/billing/screen/barcode_billing/barcode_billing_layout.dart';
import 'package:easypos/pages/store/screens/billing/screen/calculator_billing/calculator_billing_layout.dart';
import 'package:easypos/pages/store/screens/billing/widgets/select_product_items_widget.dart';
import 'package:easypos/pages/store/screens/billing/widgets/short_overview_of_bill_widget.dart';
import 'package:easypos/utils/app_colors.dart';
import 'package:easypos/utils/app_sizes.dart';
import 'package:easypos/utils/routing/smooth_page_transition.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemSelectBillingMobileLayout extends StatefulWidget {
  const ItemSelectBillingMobileLayout({super.key});

  @override
  State<ItemSelectBillingMobileLayout> createState() => _ItemSelectBillingMobileLayoutState();
}

class _ItemSelectBillingMobileLayoutState extends State<ItemSelectBillingMobileLayout> {
  @override
  Widget build(BuildContext context) {
    BillModel? currentBill = context.watch<BillingDataController>().currentBill;
    return LayoutBuilder(
      builder: (context, constraints) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor:  AppColors().billingAccentColor(billType: currentBill!.billType).withOpacity(.9),
              title: Text('Select Items', style: TextStyle(color: Colors.white, fontSize: AppSizes().normalText, fontWeight: FontWeight.bold),),
              actions: _actionBarOptionList(),
            ),
            body: Column(
              //mainAxisSize: MainAxisSize.max,
              children: [
                
                const Flexible(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SelectProductItemsWidget(),
                  ),
                ),
                Container( 
                  height: 75,
                  width: constraints.maxWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(color: Color.fromARGB(141, 0, 0, 0), blurRadius: 5)
                    ]
                    //color: AppColors().grey(),
                  ),
                  child: const ShortOverviewOfBillWidget()),
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
            Navigator.of(context).pushReplacement(SmoothPageTransition().createRoute(secondScreen: const BarcodeBillingLayout()));
          },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.qr_code_scanner_sharp, color: Colors.white,),
          )),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 2),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              Navigator.of(context).pushReplacement(SmoothPageTransition().createRoute(secondScreen: const CalculatorBillingLayout()));
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.calculate, color: Colors.white,),
            )),
        ),
      ),
    ];
  }

}