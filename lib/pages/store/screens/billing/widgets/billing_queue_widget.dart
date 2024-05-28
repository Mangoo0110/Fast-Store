import 'package:easypos/models/bill_model.dart';
import 'package:easypos/pages/store/controller/store_data_controller.dart';
import 'package:easypos/pages/store/screens/billing/controller/billing_data_controller.dart';
import 'package:easypos/pages/store/screens/billing/screen/item_select_billing/item_select_billing_layout.dart';
import 'package:easypos/utils/app_colors.dart';
import 'package:easypos/utils/app_textstyles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BillingQueueWidget extends StatelessWidget {
  const BillingQueueWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, BillModel> billingQueue = context.watch<BillingDataController>().inStoreBillQueue;
    return LayoutBuilder(
      builder: (context, constraints) {
        if(billingQueue.isEmpty) {
          return Text("No bill in queue.", style: AppTextStyle().normalSize(context: context),);
        } else{
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: billingQueue.entries.map((mapEntry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
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
                            Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (context)=> ItemSelectBillingLayout(
                                  bill: mapEntry.value)));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Payable: Tk. ${mapEntry.value.payableAmount}', style: AppTextStyle().boldNormalSize(context: context),),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        'Billed at: ${mapEntry.value.billedAt == null ? '' : mapEntry.value.billedAt!.toLocal().toString()}',
                                        style: AppTextStyle().smallSize(context: context),
                                      ),
                                    ),
                                    
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: AppColors().grey(),
                      height: 1,
                      width: constraints.maxWidth,
                    )
                  ],
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }
}