import 'package:easypos/models/bill_model.dart';
import 'package:easypos/pages/store/screens/billing/controller/billing_data_controller.dart';
import 'package:easypos/pages/store/screens/billing/screen/checkout/checkout_layout.dart';
import 'package:easypos/pages/store/screens/billing/widgets/billed_product_list_tablet_widget.dart';
import 'package:easypos/pages/store/screens/billing/widgets/select_product_items_widget.dart';
import 'package:easypos/utils/app_colors.dart';
import 'package:easypos/utils/app_sizes.dart';
import 'package:easypos/utils/app_textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ItemSelectBillingTabletLayout extends StatefulWidget {
  const ItemSelectBillingTabletLayout({super.key});

  @override
  State<ItemSelectBillingTabletLayout> createState() => _ItemSelectBillingTabletLayoutState();
}

class _ItemSelectBillingTabletLayoutState extends State<ItemSelectBillingTabletLayout> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SafeArea(
          child: Scaffold(
            body: Row(
              children: [
                SizedBox(width: constraints.maxWidth * .4, child: Padding(
                  padding: const EdgeInsets.only(right: 3.0),
                  child: _leftSide(),
                )),
                SizedBox(width: constraints.maxWidth *.6, child: Padding(
                  padding: const EdgeInsets.only(left: 3.0),
                  child: _rightSide(),
                ))
              ],
            ),
          ),
        
        );
      },
    );
  }

  Widget _leftSide() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return const CheckoutLayout();
      }
    );
  }

  Widget _rightSide() {
    BillModel? currentBill = context.watch<BillingDataController>().currentBill;
    return LayoutBuilder(
      builder: (context, constraints) {
        if(currentBill == null) {
          return const Center(child:  CircularProgressIndicator(),);
        }
        return Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            automaticallyImplyLeading: false,
            backgroundColor: AppColors().billingAccentColor(billType: currentBill.billType),
            title: Text('Select Items', style: TextStyle(color: Colors.white, fontSize: AppSizes().normalText, fontWeight: FontWeight.bold),),
            actions: _actionBarOptionList(),
          ),
          body: const Padding(
            padding: EdgeInsets.all(8.0),
            child: SelectProductItemsWidget()),
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