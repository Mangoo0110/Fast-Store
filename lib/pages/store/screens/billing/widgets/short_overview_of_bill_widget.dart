import 'package:easypos/common/widgets/show_round_image.dart';
import 'package:easypos/models/bill_model.dart';
import 'package:easypos/models/billing_product.dart';
import 'package:easypos/pages/store/controller/store_data_controller.dart';
import 'package:easypos/pages/store/screens/billing/controller/billing_data_controller.dart';
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
  final BillModel billModel;
  const ShortOverviewOfBillWidget({super.key, required this.billModel});

  @override
  Widget build(BuildContext context) {
    final BillModel bill = context.watch<BillingDataController>().inStoreBillQueue[billModel.billId]!;

    final List<BillingProduct> billedProductList = bill.idMappedBilledProductList.entries.map((mapEntry) {
      return mapEntry.value;
    }).toList();

    billedProductList.sort((a,b)=> -(a.totalPrice.compareTo(b.totalPrice)));

    double totalTax = 0;
    bill.taxNameMapPercentage.forEach((key, value) {
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
              Flexible(child: _row1(constraints: constraints, context: context, )),
              Flexible(child: _row2(constraints: constraints, context: context, thisBill: bill, billedProductList: billedProductList)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.0),
                child: _row3(constraints: constraints, context: context, thisBill: bill),
              ),
              _row4(constraints: constraints, context: context, thisBill: bill)
            ],
          ),
        );
      },
    );
  }

  Widget _row1({required BoxConstraints constraints, required BuildContext context}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: SizedBox(
            width: constraints.maxWidth * .65,
            height: 50,
            child: const PaymentMethodWidget()),
        ),
        
        CustomerDetailsWidget(
          onEntry: (customerName, customerContactNo) {
            
          }, 
          customerName: '', 
          customerContactNo: '')
      ],
    );
  }

  Widget _row2({required BoxConstraints constraints, required BuildContext context, required BillModel thisBill, required List<BillingProduct> billedProductList}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: SizedBox(
            width: constraints.maxWidth * .35,
            child: _payableAmount(constraints: constraints, context: context, thisBill: thisBill)),
        ),
        Flexible(
          child: SizedBox(
            height: 50,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(4),
                onTap: () {
                  Navigator.push(context, SmoothPageTransition().createRoute(secondScreen: BilledProductListWidget(billId: billModel.billId)));
                },
                child: _productStack(constraints: constraints, context: context, billedProductList: billedProductList)),
            ),
          )),
      ],
    );
  }

  Widget _row3({required BoxConstraints constraints, required BuildContext context, required BillModel thisBill}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _recievedAmount(constraints: constraints, context: context, thisBill: thisBill),
        _dueChange(constraints: constraints, context: context, thisBill: thisBill),
      ],
    );
  }

  Widget _row4({required BoxConstraints constraints, required BuildContext context, required BillModel thisBill}) {
    return Table(
      columnWidths: const{0: FlexColumnWidth(.5), 1: FlexColumnWidth(.5), },
      children: [
        TableRow(
          children: [
            // SizedBox(
            //   height: 56,
            //   child: Padding(
            //     padding: const EdgeInsets.only(left: 2.0),
            //     child: _detailsButton(constraints: constraints, context: context, bill: thisBill),
            //   )),
            SizedBox(
              height: 56,
              child: Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: _orderTicketButton(constraints: constraints, context: context, bill: thisBill),
              )),
            SizedBox(
              height: 56,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: _saveButton(constraints: constraints, context: context, payableAmount: thisBill.payableAmount),
              )),
          ],
        )
      ],
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
                padding: const EdgeInsets.all(2.0),
                child: Text('+ ${billedProductList.length + 1 - cnt} more', style: const TextStyle(fontSize: 8, color: Colors.white),),
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

  Widget _recievedAmount({required BoxConstraints constraints, required BuildContext context, required BillModel thisBill}) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2),
            child: Row(
              children: [
                Text("Amt. received: ", style: AppTextStyle().boldSmallSize(context: context),),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10),
                    child: Text(
                      thisBill.totalAmountReceived <= 0 ? thisBill.payableAmount.toString() : thisBill.totalAmountReceived.toString(),
                      style: AppTextStyle().normalSize(context: context),),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dueChange({required BoxConstraints constraints, required BuildContext context, required BillModel thisBill}) {
    final double dueAmount = thisBill.payableAmount - thisBill.totalAmountReceived ;
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text( '${(dueAmount > 0) ? 'Due' : 'Change'}: ${dueAmount.abs()}', style: AppTextStyle().boldSmallSize(context: context),),
    );
  }

  Widget _payableAmount({required BoxConstraints constraints, required BuildContext context, required BillModel thisBill}) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text( 'Payable: ${thisBill.payableAmount.toString()}', style: AppTextStyle().boldSmallSize(context: context),),
    );
  }

  Widget _saveButton({required BoxConstraints constraints, required BuildContext context, required double payableAmount}) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.green
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text("SAVE (${payableAmount.toString()})", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
          ),
        ),
      ),
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
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4),
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

  Widget _detailsButton({required BoxConstraints constraints, required BuildContext context, required BillModel bill}) {
    return Container(
      height: constraints.maxHeight,
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
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4),
            child: Center(child: Text("DETAILS", style: AppTextStyle().boldNormalSize(context: context),)),
          ),
        ),
      ),
    );
  }
  

}