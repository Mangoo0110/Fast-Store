import 'package:dotted_border/dotted_border.dart';
import 'package:easypos/common/widgets/show_round_image.dart';
import 'package:easypos/models/bill_model.dart';
import 'package:easypos/models/billing_product.dart';
import 'package:easypos/pages/store/controller/store_data_controller.dart';
import 'package:easypos/pages/store/screens/billing/controller/billing_data_controller.dart';
import 'package:easypos/pages/store/screens/billing/screen/invoice/invoice_layout.dart';
import 'package:easypos/pages/store/screens/billing/widgets/billed_product_list_widget.dart';
import 'package:easypos/pages/store/screens/billing/widgets/customer_details_widget.dart';
import 'package:easypos/pages/store/screens/billing/widgets/payment_method_choose_widget.dart';
import 'package:easypos/utils/app_colors.dart';
import 'package:easypos/utils/app_sizes.dart';
import 'package:easypos/utils/app_textstyles.dart';
import 'package:easypos/utils/routing/smooth_page_transition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ShortOverviewOfBillWidget extends StatelessWidget {
  final String billId;
  const ShortOverviewOfBillWidget({super.key, required this.billId});

  @override
  Widget build(BuildContext context) {
    final BillModel thisBill = context.watch<BillingDataController>().inStoreBillQueue[billId]!;

    final List<BillingProduct> billedProductList = thisBill.idMappedBilledProductList.entries.map((mapEntry) {
      return mapEntry.value;
    }).toList();

    billedProductList.sort((a,b)=> -(a.totalPrice.compareTo(b.totalPrice)));

    double totalTax = 0;
    thisBill.taxNameMapPercentage.forEach((key, value) {
      totalTax += value;
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Flexible(child: _row1(constraints: constraints, context: context, )),
              Flexible(child: _row2(thisBill: thisBill, billedProductList: billedProductList)),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 0.0),
              //   child: _row3(constraints: constraints, context: context, thisBill: bill),
              // ),
              Padding(
                padding: const EdgeInsets.only(top: 3.0),
                child: _row4(thisBill: thisBill),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _row2({required BillModel thisBill, required List<BillingProduct> billedProductList}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: SizedBox(
                height: 50,
                width: constraints.maxWidth,
                child: _orderTicketButton(constraints: constraints, context: context, bill: thisBill))
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: SizedBox(
                  height: 50,
                  width: constraints.maxWidth,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(4),
                      onTap: () {
                        //Navigator.push(context, SmoothPageTransition().createRoute(secondScreen: BilledProductListWidget(billId: billId)));
                      },
                      child: _productStack(constraints: constraints, context: context, billedProductList: billedProductList)),
                  ),
                ),
              )),
          ],
        );
      }
    );
  }


  Widget _row4({required BillModel thisBill}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [
            Flexible(
              child: SizedBox(
                height: 56,
                width: constraints.maxWidth,
                child: _holdButton()),
            ),
            Flexible(
              child: SizedBox(
                height: 56,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: _saveButton(thisBill: thisBill),
                )),
            ),
          ],
        );
      }
    );
  }

  Widget _productStack({required BoxConstraints constraints, required BuildContext context, required List<BillingProduct> billedProductList,}) {
    int cnt = 0;
    return Stack(
      children: billedProductList.map((mapEntry){
        cnt++;
        if(cnt == 5) {
          return Positioned(
            left: (cnt - 1) * 25,
            top: 28,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors().grey(),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 6),
                child: Text('+ ${billedProductList.length + 1 - cnt} more', style: const TextStyle(fontSize: 8, color: Colors.black),),
              ),
            ),
          );
        } else if(cnt > 5) {
          return Container();
        }
        return Positioned(
          left: (cnt - 1) * 25,
          top: 0,
          child: ShowRoundImage(
            image: context.read<StoreDataController>().imageIfExist(imageId: mapEntry.productImageId), 
            height: 40, width: 40, borderRadius: 5000000,),
        );
      }).toList()
    );
  }

  Widget _payableAmount({required BoxConstraints constraints, required BuildContext context, required BillModel thisBill}) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text( 'Payable: ${thisBill.payableAmount.toString()}', style: AppTextStyle().boldSmallSize(context: context),),
    );
  }

  Widget _saveButton({required BillModel thisBill}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.green
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                if(thisBill.subTotal <= 0) {
                  return;
                } 
                Navigator.push(context, SmoothPageTransition().createRoute(secondScreen: InvoiceLayout(bill: thisBill)));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const Text("Payable: ", style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.normal),),
                        Text("${thisBill.payableAmount.toString()} Tk.", style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal),),
                      ],
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Proceed", style: TextStyle(color: Colors.white, fontSize: AppSizes().normalText, fontWeight: FontWeight.bold),),
                          const Icon(Icons.arrow_forward, color: Colors.white, size: 20,)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  Widget _orderTicketButton({required BoxConstraints constraints, required BuildContext context, required BillModel bill}) {
    return Container(
      
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black)
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("OT", style: AppTextStyle().boldNormalSize(context: context),),
                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Text("(order ticket)", style: AppTextStyle().smallSize(context: context),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _holdButton(){
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.green),
            color: Colors.white,
            boxShadow: const [
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
                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.pause, color: Colors.green,),
                    Padding(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: Text('Hold', style: TextStyle(color: Colors.green, fontSize: AppSizes().normalText, fontWeight: FontWeight.bold),),
                    )
                  ],
                ),
              )),
          ),
        );
      },
    );
  }

}