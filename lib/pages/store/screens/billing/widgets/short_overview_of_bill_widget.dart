import 'package:easypos/common/widgets/image_related/show_round_image.dart';
import 'package:easypos/common/widgets/text_widgets.dart';
import 'package:easypos/models/bill_model.dart';
import 'package:easypos/models/billing_product.dart';
import 'package:easypos/pages/store/controller/store_data_controller.dart';
import 'package:easypos/pages/store/screens/billing/controller/billing_data_controller.dart';
import 'package:easypos/pages/store/screens/billing/screen/checkout/checkout_layout.dart';
import 'package:easypos/utils/app_colors.dart';
import 'package:easypos/utils/app_sizes.dart';
import 'package:easypos/utils/app_textstyles.dart';
import 'package:easypos/utils/routing/smooth_page_transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ShortOverviewOfBillWidget extends StatefulWidget {
  const ShortOverviewOfBillWidget({super.key});

  @override
  State<ShortOverviewOfBillWidget> createState() => _ShortOverviewOfBillWidgetState();
}

class _ShortOverviewOfBillWidgetState extends State<ShortOverviewOfBillWidget> {
  BillModel? currentBill;
  Color _actionColor = Colors.orange;
  BillType selectedBillType = BillType.walking;

  @override
  Widget build(BuildContext context) {
    currentBill = context.watch<BillingDataController>().currentBill;

    if(currentBill == null) {
      return const Center(child: CircularProgressIndicator(),);
    }

    final List<BillingProduct> billedProductList = currentBill!.idMappedBilledProductList.entries.map((mapEntry) {
      return mapEntry.value;
    }).toList();

    billedProductList.sort((a,b)=> -(a.totalPrice.compareTo(b.totalPrice)));

    _actionColor = AppColors().billingAccentColor(billType: currentBill!.billType);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 3.0),
                child: _row4(thisBill: currentBill!),
              )
            ],
          ),
        );
      },
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
                child: _billTypeButton()),
            ),
            Flexible(
              child: SizedBox(
                height: 56,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: _proceedButton(thisBill: thisBill),
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

  Widget _proceedButton({required BillModel thisBill}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: _actionColor
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                if(thisBill.subTotal <= 0) {
                  return;
                } 
                Navigator.push(context, SmoothPageTransition().createRoute(secondScreen: const CheckoutLayout()));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          const Text("Payable: ", style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.normal),),
                          Flexible(child: Text("${thisBill.payableAmount.toString()} Tk.", style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal, overflow: TextOverflow.ellipsis),)),
                        ],
                      ),
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

 
  Widget _billTypeButton(){
    selectedBillType = currentBill!.billType;
    Map<String, BillType> billTypeMap = {
      "Walking" : BillType.walking,
      "Delivery" : BillType.delivery,
    };
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: _actionColor),
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
                child: Material(
                  color: Colors.transparent,
                  child: DropdownButton(
                    borderRadius: BorderRadius.circular(8),
                    enableFeedback: true,
                    underline: Container(),
                    //isExpanded: true,
                    padding: const EdgeInsets.all(8),
                    hint: TextWidgets().highLightText(text: selectedBillType == BillType.delivery ? 'Delivery' : 'Walking', textColor: Colors.black.withOpacity(.85)),
                    onChanged: (billType) {
                      if(billType != null) {
                        setState(() {
                          selectedBillType = billType;
                          context.read<BillingDataController>().changeCurrentBillType(billType: selectedBillType,);
                        });
                      }
                    },
                    items: billTypeMap.entries.map((billTypeEntry) {
                      return DropdownMenuItem(
                        value: billTypeEntry.value, 
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          child: Text(billTypeEntry.key, style: AppTextStyle().normalSize(context: context),),
                        ), 
                      );
                    }
                  ).toList()),
                ),
              )),
          ),
        );
      },
    );
  }


}