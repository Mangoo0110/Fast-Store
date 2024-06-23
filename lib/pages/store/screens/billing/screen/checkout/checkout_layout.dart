import 'package:easypos/common/widgets/text_widgets.dart';
import 'package:easypos/models/bill_model.dart';
import 'package:easypos/pages/store/controller/store_data_controller.dart';
import 'package:easypos/pages/store/screens/billing/controller/billing_data_controller.dart';
import 'package:easypos/pages/store/screens/billing/screen/checkout/popups/payment_popup.dart';
import 'package:easypos/pages/store/screens/billing/screen/checkout/widgets/payable_details_widget.dart';
import 'package:easypos/pages/store/screens/billing/widgets/billed_product_list_widget.dart';
import 'package:easypos/pages/store/screens/main/store_view.dart';
import 'package:easypos/utils/app_colors.dart';
import 'package:easypos/utils/app_themes.dart';
import 'package:easypos/utils/dekhao.dart';
import 'package:easypos/utils/routing/smooth_page_transition.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckoutLayout extends StatefulWidget {
  const CheckoutLayout({super.key});

  @override
  State<CheckoutLayout> createState() => _CheckoutLayoutState();
}

class _CheckoutLayoutState extends State<CheckoutLayout> {

  // final List<String> sectionNameList = ['Customer Info', 'Billed Products', 'Payable Info', ];

  // final List<GlobalKey> sectionKeyList = [GlobalKey(), GlobalKey(), GlobalKey()];

  double receivedMoney = 0;

  BillModel? currentBill;


  BillType selectedBillType = BillType.walking;

  final _focusNode = FocusNode();

  void scrollToSection({required GlobalKey key}) {
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCirc);
  }

  @override
  void initState() {
    currentBill = context.read<BillingDataController>().currentBill;
    if(currentBill == null) {
      Navigator.pop(context);
    }
    // TODO: implement initState
    receivedMoney = currentBill!.totalReceivedAmount;
    if(receivedMoney <= 0) {
      receivedMoney = currentBill!.payableAmount;
    }
    
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    currentBill = context.watch<BillingDataController>().currentBill;

    if(currentBill == null) {
      return Center(
        child: TextWidgets().highLightText(text: 'Bill check not found!', textColor: Colors.black.withOpacity(.7)),
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        dekhao("build constraints.maxWidth  = ${constraints.maxWidth}");
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              iconTheme: AppTheme().iconThemeData(),
              backgroundColor: AppColors().billingAccentColor(billType: currentBill!.billType).withOpacity(.8),
              title: _billTypeButton(),
              centerTitle: false,
            ),
            body: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 4),
                                    child: _billedProductList(constraints: constraints),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                       
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: PayableDetailsWidget(currentBill: currentBill!),
                      ),
                      Table(
                        columnWidths: const {0: FlexColumnWidth(.5), 1: FlexColumnWidth(.5)},
                        children: [
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: _saveHoldButton(),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: _payButton(currentBill!),
                              ),
                            ]
                          )
                        ],
                      ),
                    ],
                  )
                  //  _saveHoldAndPayButton()
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _saveHoldButton() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: 50,
          width: constraints.maxWidth,
          decoration: BoxDecoration(
            color: Colors.transparent,//AppColors().billingAccentColor(billType: currentBill!.billType).withOpacity(.9),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.black.withOpacity(.8))
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async{
                await context.read<BillingDataController>()
                  .holdBilledCheck(
                    storeId: context.read<StoreDataController>().currentStore!.storeId)
                      .then((value) {
                        Navigator.pushAndRemoveUntil(context, SmoothPageTransition().createRoute(secondScreen: const StoreView()), (route) => false);
                      });
               
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Center(child: TextWidgets().buttonText(buttonText: 'Save & Hold', textColor: Colors.black)),
              ),
            ),
          ),
        );
      },
    );
  
  }

  Widget _payButton(BillModel bill) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: 50,
          width: constraints.maxWidth,
          decoration: BoxDecoration(
            color: Colors.greenAccent.shade700.withOpacity(.6),//AppColors().billingAccentColor(billType: currentBill!.billType).withOpacity(.9),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(context: context, builder:(context) => PaymentPopup(billId: currentBill!.billId),);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Center(child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidgets().buttonTextHigh(buttonText: 'Pay', textColor: Colors.black),
                  ],
                )),
              ),
            ),
          ),
        );
      
      },
    );
  
  }

  Widget _billedProductList({required BoxConstraints constraints}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        // border: Border.all(
        //   color: Colors.black.withOpacity(.3)
        // ),
        borderRadius: BorderRadius.circular(4),
        // boxShadow: const[
        //   BoxShadow(color: Color(0x1F000000), blurRadius: 8)
        // ]
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidgets().highLightText(text: 'Billed products', textColor: Colors.black.withOpacity(.6)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 2),
              child: BilledProductListWidget(
                billedProductList: currentBill!.idMappedBilledProductList.entries.map((e) => e.value).toList()),
            ),
          ],
        ),
      ),
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
        return Material(
          color: Colors.transparent,
          child: DropdownButton(
            borderRadius: BorderRadius.circular(8),
            enableFeedback: true,
            underline: Container(),
            //isExpanded: true,
            focusNode: _focusNode,
            iconEnabledColor: Colors.white,
            iconDisabledColor: Colors.white,
            padding: const EdgeInsets.all(8),
            hint: TextWidgets().highLightText(text: selectedBillType == BillType.delivery ? 'Delivery' : 'Walking', textColor: Colors.white),
            onChanged: (billType) {
              if(billType != null) {
                setState(() {
                  selectedBillType = billType;
                  context.read<BillingDataController>().changeCurrentBillType(billType: selectedBillType);
                  _focusNode.unfocus();
                });
              }
            },
            items: billTypeMap.entries.map((billTypeEntry) {
              return DropdownMenuItem(
                value: billTypeEntry.value, 
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: TextWidgets().buttonText(buttonText: billTypeEntry.key, textColor: Colors.black)
                ), 
              );
            }
          ).toList()),
        );
      },
    );
  }



}