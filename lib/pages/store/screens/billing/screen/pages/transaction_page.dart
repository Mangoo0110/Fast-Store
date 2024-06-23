import 'package:easypos/common/widgets/money.dart';
import 'package:easypos/common/widgets/text_widgets.dart';
import 'package:easypos/models/bill_model.dart';
import 'package:easypos/models/delivery_info_model.dart';
import 'package:easypos/pages/store/controller/store_data_controller.dart';
import 'package:easypos/pages/store/screens/billing/controller/billing_data_controller.dart';
import 'package:easypos/utils/app_colors.dart';
import 'package:easypos/utils/app_textstyles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  
  double outerPadding = 6;

  @override
  void initState() {
    // TODO: implement initState
    context.read<BillingDataController>()
      .fetchProcessedBillList(storeId: context.read<StoreDataController>().currentStore!.storeId, date: DateTime.now());
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Padding(
            padding: EdgeInsets.all(outerPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidgets().highLightText(text: "Processed transactions: ", textColor: Colors.grey),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: _processedTransactions(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _processedTransactions() {
    final Map<String, BillModel> processedBills = context.watch<BillingDataController>().processedBills;
    return LayoutBuilder(
      builder: (context, constraints) {
        if(processedBills.isEmpty) {
          return Center(child: Text("NO BILLS", style: AppTextStyle().normalSize(context: context),));
        } else{
          return SingleChildScrollView(
            child: Column(
              children: processedBills.entries.map((mapEntry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors().billTileColor(billType: mapEntry.value.billType),
                      //borderRadius: BorderRadius.circular(4),
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
                          
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  mapEntry.value.billType == BillType.walking ?
                                  Icon(Icons.run_circle_outlined, color: AppColors().billingAccentColor(billType: mapEntry.value.billType),)
                                  :
                                  Row(
                                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(Icons.delivery_dining, color: AppColors().billingAccentColor(billType: mapEntry.value.billType),),
                                      mapEntry.value.deliveryInfo!.deliveryPhase == DeliveryPhase.delivered ?
                                        TextWidgets().highLightText(text: ' Delivered', textColor: Colors.green)
                                      :
                                        mapEntry.value.deliveryInfo!.deliveryDateTime.compareTo(DateTime.now()) < 0 ?
                                          TextWidgets().highLightText(text: ' Late', textColor: Colors.black)
                                        :
                                          TextWidgets().highLightText(text: ' Yet to deliver', textColor: AppColors().billingAccentColor(billType: mapEntry.value.billType))
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Row(
                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextWidgets().highLightText(text: mapEntry.value.payableAmount.toString(), textColor: Colors.black),
                                        mapEntry.value.dueAmount > 0 ?
                                          TextWidgets().highLightText( text: "  (${Money().moneyText(moneyValue: mapEntry.value.dueAmount)} Due)", textColor:  Colors.red.shade400 )
                                        :
                                          TextWidgets().highLightText(text: ' PAID ', textColor:  Colors.green),
                                      ],
                                    ),
                                  ),
                                  
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: TextWidgets().normalText(text: mapEntry.value.billedAt == null ? '' :  "${DateFormat.MMMEd().format(mapEntry.value.billedAt!.toLocal())}, ${DateFormat.jm().format(mapEntry.value.billedAt!.toLocal())}", textColor: Colors.black),
                                  ),

                                  

                                  Row(
                                    children: [
                                      TextWidgets().highLightText(text: "Bill Id: ", textColor: Colors.grey),
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

}