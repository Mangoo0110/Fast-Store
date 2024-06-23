import 'package:easypos/common/widgets/text_widgets.dart';
import 'package:easypos/models/bill_model.dart';
import 'package:easypos/pages/store/controller/store_data_controller.dart';
import 'package:easypos/pages/store/screens/billing/controller/billing_data_controller.dart';
import 'package:easypos/pages/store/screens/billing/screen/item_select_billing/item_select_billing_layout.dart';
import 'package:easypos/utils/app_colors.dart';
import 'package:easypos/utils/app_textstyles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  @override
  void initState() {
    // TODO: implement initState
    context.read<BillingDataController>().fetchOnHoldBillList(storeId: context.read<StoreDataController>().currentStore!.storeId);
    super.initState();
  }
  double outerPadding = 6;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          backgroundColor: AppColors().appBackgroundColor(context: context),
          body: Padding(
            padding: EdgeInsets.all(outerPadding),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: constraints.maxWidth / 2 - outerPadding ,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: _saleNumber(),
                      ),
                    ),
                    SizedBox(
                      width: constraints.maxWidth / 2 - outerPadding,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: _transactionNumber(),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                     // border: Border.all(color: Colors.black, width: .5),
                      borderRadius: BorderRadius.circular(6)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidgets().highLightText(text: "Checks on hold", textColor: Colors.grey),
                          Flexible(child: _onHoldBillQueueWidget())
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _onHoldBillQueueWidget() {
    final Map<String, BillModel> onHoldBillQueue = context.watch<BillingDataController>().onHoldBillQueue;
    return LayoutBuilder(
      builder: (context, constraints) {
        if(onHoldBillQueue.isEmpty) {
          return Center(child: Text("No bills/checks", style: AppTextStyle().normalSize(context: context),));
        } else{
          return SingleChildScrollView(
            child: Column(
              children: onHoldBillQueue.entries.map((mapEntry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors().billTileColor(billType: mapEntry.value.billType),
                      border: const Border(bottom: BorderSide(color: Colors.black, width: .5))
                      // boxShadow: const[
                      //   BoxShadow(
                      //     color: Colors.black,
                      //     blurRadius: 3
                      //   )
                      // ]
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          context.read<BillingDataController>().setCurrentBill(bill: mapEntry.value);
                          Navigator.push(
                            context, 
                            MaterialPageRoute(
                              builder: (context)=> const ItemSelectBillingLayout()
                            )
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      mapEntry.value.billType == BillType.walking ?
                                      Icon(Icons.run_circle_outlined, color: AppColors().billingAccentColor(billType: mapEntry.value.billType),)
                                      :
                                      Icon(Icons.delivery_dining, color: AppColors().billingAccentColor(billType: mapEntry.value.billType),),
                                      TextWidgets().normalText(text: " | ", textColor: Colors.black),
                                      TextWidgets().normalText(text: mapEntry.value.billedAt == null ? '' :  DateFormat.jm().format(mapEntry.value.billedAt!.toLocal()), textColor: Colors.black)
                                    ],
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text('Payable: Tk. ${mapEntry.value.payableAmount}', style: AppTextStyle().boldNormalSize(context: context),),
                                  ),

                                  Row(
                                    children: [
                                      TextWidgets().normalText(text: "Bill Id: ", textColor: Colors.black),
                                      TextWidgets().normalText(text: mapEntry.value.billId, textColor: Colors.black),
                                    ],
                                  )
                                  
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }
      },
    );
  
  }
  
  Widget _saleNumber() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(6)
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidgets().buttonText(buttonText: 'BDT *****', textColor: Colors.black),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextWidgets().buttonTextHigh(buttonText: 'Total Sale', textColor: Colors.orange.shade300,),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _transactionNumber() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(6)
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidgets().buttonText(buttonText: '***', textColor: Colors.black),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextWidgets().buttonTextHigh(buttonText: 'Transactions', textColor: Colors.greenAccent.shade700.withOpacity(.6)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}