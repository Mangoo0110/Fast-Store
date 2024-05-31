import 'package:easypos/models/bill_model.dart';
import 'package:easypos/pages/store/screens/billing/widgets/billed_product_list_tablet_widget.dart';
import 'package:easypos/pages/store/screens/billing/widgets/select_product_items_widget.dart';
import 'package:easypos/utils/app_colors.dart';
import 'package:easypos/utils/app_sizes.dart';
import 'package:easypos/utils/app_textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BarcodeBillingTabletLayout extends StatefulWidget {
  final BillModel bill;
  const BarcodeBillingTabletLayout({super.key, required this.bill});

  @override
  State<BarcodeBillingTabletLayout> createState() => _BarcodeBillingTabletLayoutState();
}

class _BarcodeBillingTabletLayoutState extends State<BarcodeBillingTabletLayout> {
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
            
          },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.inventory_outlined, color: Colors.white,),
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