import 'package:easypos/common/widgets/text_widgets.dart';
import 'package:easypos/models/bill_model.dart';
import 'package:easypos/pages/store/screens/billing/controller/billing_data_controller.dart';
import 'package:easypos/pages/store/screens/billing/screen/checkout/popups/customer_details_popup.dart';
import 'package:easypos/utils/app_colors.dart';
import 'package:easypos/utils/app_textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class PayableDetailsWidget extends StatefulWidget {
  final BillModel currentBill;
  const PayableDetailsWidget({super.key, required this.currentBill});

  @override
  State<PayableDetailsWidget> createState() => _PayableDetailsWidgetState();
}

class _PayableDetailsWidgetState extends State<PayableDetailsWidget> {
  BillModel? currentBill;
  @override
  Widget build(BuildContext context) {
    currentBill = context.watch<BillingDataController>().currentBill;
    return LayoutBuilder(
      builder: (context, constraints) {
        if(currentBill == null) {
          return const Center(child: CircularProgressIndicator(),);
        }
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.white,
            border: Border.all(color: Colors.black.withOpacity(.3)),
            // boxShadow: const[
            //   BoxShadow(color: Color(0x1F000000), blurRadius: 8)
            // ]
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _customerInfo(),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: TextWidgets().highLightText(text: 'Total summary', textColor: Colors.black.withOpacity(.7)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: _money(),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _money() {
    BillModel bill = widget.currentBill;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Subtotal", style: AppTextStyle().normalSize(context: context),),
                  Text(bill.subTotal.toString(), style: AppTextStyle().normalSize(context: context),),
                ],
              ),
            ),
        
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text("Discount(${bill.discountPercentage.toString()}%)", style: AppTextStyle().normalSize(context: context),),
                          const Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Icon(Icons.keyboard_arrow_right, color: Colors.black,),
                          )
                        ],
                      ),
                      Text("- ${bill.discountValue.toString()}", style: AppTextStyle().normalSize(context: context),),

                    ],
                  ),
                ),
              ),
            ),
        
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total Payable", style: AppTextStyle().normalSize(context: context),),
                  Row(
                    children: [
                      Text(bill.payableAmount.toString(), style: AppTextStyle().normalSize(context: context),),
                    ],
                  ),
                ],
              ),
            ),
        
          ],
        );
      }
    );
  }
  Widget _customerInfo() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if(currentBill!.customerContactNo.isEmpty) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(context: context, builder:(context) => CustomerDetailsPopup(currentBillId: widget.currentBill.billId),);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      //mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.person_add, size: 28, color: Colors.black,),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: TextWidgets().buttonTextHigh(buttonText: 'Add customer', textColor: Colors.black),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Container(color: Colors.black, width: constraints.maxWidth, height: .8,),
                )
                ],
              ),
            ),
          );
        }
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(context: context, builder:(context) => CustomerDetailsPopup(currentBillId: widget.currentBill.billId),);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors().billingAccentColor(billType: currentBill!.billType),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextWidgets().buttonTextHigh(buttonText: currentBill!.customerName.split(" ").first[0], textColor: Colors.black),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(child: TextWidgets().highLightText(text: currentBill!.customerName, textColor: Colors.black)),
                              Flexible(child: TextWidgets().buttonText(buttonText: currentBill!.customerContactNo, textColor: Colors.grey)),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Container(color: Colors.black, width: constraints.maxWidth, height: .8,),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}