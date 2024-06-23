import 'dart:math';

import 'package:easypos/common/data/app_regexp.dart';
import 'package:easypos/common/widgets/money.dart';
import 'package:easypos/common/widgets/text_widgets.dart';
import 'package:easypos/models/bill_model.dart';
import 'package:easypos/models/payment_model.dart';
import 'package:easypos/pages/store/controller/store_data_controller.dart';
import 'package:easypos/pages/store/screens/billing/controller/billing_data_controller.dart';
import 'package:easypos/pages/store/screens/main/store_view.dart';
import 'package:easypos/utils/app_textstyles.dart';
import 'package:easypos/utils/dekhao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

class PaymentPopup extends StatefulWidget {
  final String billId;
  const PaymentPopup({super.key, required this.billId});

  @override
  State<PaymentPopup> createState() => _PaymentPopupState();
}

class _PaymentPopupState extends State<PaymentPopup> {

  double selectedAmount = 0;
  PaymentModel currentPayment = PaymentModel(transactionId: '', paymentMethod: PaymentMethod.cash, paidAmount: 0, transactionAt: DateTime.now());

  TextEditingController _amountController = TextEditingController();

  final FocusNode _focusNode = FocusNode(); 

  final amountEntryFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    currentBill = context.read<BillingDataController>().currentBill;
    _amountController.text = '0' ;
    super.initState();
  }
  
  BillModel? currentBill;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CupertinoPageScaffold(
          child: Container(
            color: Colors.white,
            width: constraints.maxWidth,
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Container(
                      width: 100,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.4),
                        borderRadius: BorderRadius.circular(8)
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
                    child: popupHeader(),
                  ),

                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: _amountInputField(),
                          ),
                      
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: _cash(),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: _confirmButton(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget popupHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: constraints.maxWidth/2, child: TextWidgets().popupHeader(headerText: 'Pay', textColor: Colors.black.withOpacity(1))),
                SizedBox(
                  width: constraints.maxWidth/2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(child: TextWidgets().highLightText(text: Money().moneyText(moneyValue: (currentBill!.dueAmount - selectedAmount).abs()), textColor: Colors.black.withOpacity(.4))),
                      TextWidgets().highLightText(text: (currentBill!.dueAmount - selectedAmount) > 0 ? " (Due) " : " (Change) ", textColor: Colors.black.withOpacity(.7)),
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Container(
                width: constraints.maxWidth,
                height: .8,
                color: Colors.black.withOpacity(.8),
              ),
            )
          ],
        );
      },
    );
  }

    Widget _amountInputField() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: constraints.maxWidth * .35,
              height: 55,
              child: Row(
                children: [
                  TextWidgets().highLightText(text: 'Cash ', textColor: Colors.black.withOpacity(.7)),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(.8),
                      borderRadius: BorderRadius.circular(1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(top: BorderSide(color: Colors.black.withOpacity(.4)), bottom: BorderSide(color: Colors.black.withOpacity(.4)),)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: .5),
                          child: TextWidgets().highLightText(text: Money().moneySymbol(context: context), textColor: Colors.black),
                        ),
                      ),
                    ),
                  )
                  //const Icon(Icons.money, color: Colors.green, size: 30,)
                ],
              )),
            SizedBox(
              height: 55,
              width: min(200, constraints.maxWidth * .65),
              child: Center(
                child: Form(
                  key: amountEntryFormKey,
                  child: TextFormField(
                    showCursor: true,
                    onTapOutside: (event){
                      _focusNode.unfocus();
                    },
                    focusNode: _focusNode,
                    maxLines: 2,
                    controller: _amountController,
                    style: AppTextStyle().normalSize(context: context),
                    textDirection: TextDirection.rtl,
                    decoration: InputDecoration(
                      isDense: true,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      alignLabelWithHint: false,
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      hintText: '',
                      labelText: 'Amount(BDT)',
                      labelStyle: AppTextStyle().bigSize(context: context),
                      hintStyle: const TextStyle(color: Colors.grey),
                      errorStyle: const TextStyle(fontSize: 7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8000000000),
                        borderSide: BorderSide(
                          color: Colors.blue.shade200,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8000000000),
                        borderSide: BorderSide(
                          color: Colors.blue.shade400,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8000000000),
                        borderSide: BorderSide(
                          color: Colors.black.withOpacity(.8),
                        ),
                      ),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(moneyRegExp()),
                    ],
                    onChanged: (value) {
                      amountEntryFormKey.currentState!.validate();
                    },
                    validator: (value) {
                      if(value == null || value.isEmpty) {
                        return 'Can not be empty';
                      }
                      double amount = -1;
                      amount = double.tryParse(value) ?? -1;
                      if(amount < 0) {
                        return 'Enter valid amount e.g. 12, 12.11, 12.000001, 12.0000000001';
                      } else {
                        selectedAmount = amount;
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      });
  }

  Widget _cash() {
    List<double> amountSuggestion = [currentBill!.dueAmount];

    List<int> currencies = Money().currencies;

    for (final int currency in currencies) {

      double suggestion = (currentBill!.dueAmount + currency) - (currentBill!.dueAmount + currency) % currency;

      if(!amountSuggestion.contains(suggestion)) {
        amountSuggestion.add(suggestion);
      }

    }

    return LayoutBuilder(
      builder: (context, constraints) {
        int cnt = -1;
        return Wrap(
          spacing: 4,
          runSpacing: 4,
          children: amountSuggestion.map((amount) {
            cnt ++;
            return Container(
              decoration: BoxDecoration(
                color: (amount == selectedAmount) ? Colors.black.withOpacity(.85) : Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.black)
                // boxShadow: const[
                //   BoxShadow(color: Color(0x1F000000), blurRadius: 8)
                // ]
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    if(_amountController.text != amount.toString()){
                      selectedAmount = amount;
                      _amountController.text = selectedAmount.toString();
                    } else {
                      selectedAmount = 0;
                      _amountController.text = selectedAmount.toString();
                    }
                    
                    
                    setState(() {
                      if(amountEntryFormKey.currentState != null) {
                        amountEntryFormKey.currentState!.validate();
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14),
                    child: TextWidgets().buttonText(buttonText: amount.toString(), textColor: (amount != selectedAmount) ? Colors.black.withOpacity(.85) : Colors.white),
                  ),
                ),
              ),
            ).animate().fade().scaleXY(begin: 0, end: 1, curve: Curves.easeInSine, duration: Duration(milliseconds: cnt * 100));
          }).toList()
        );
      },
    );
  }

  Widget _confirmButton() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: 50,
          width: constraints.maxWidth,
          decoration: BoxDecoration(
            color: selectedAmount <= 0 ? Colors.transparent : Colors.greenAccent.shade700.withOpacity(.6),//AppColors().billingAccentColor(billType: currentBill!.billType).withOpacity(.9),
            borderRadius: BorderRadius.circular(4),
            border: selectedAmount <= 0 ? Border.all(color: Colors.black) : null
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if(selectedAmount > 0) {

                  currentPayment.transactionAt = DateTime.now();
                  currentPayment.paidAmount = min(selectedAmount, currentBill!.dueAmount);
                  currentPayment.transactionAt = DateTime.now();

                  dekhao("selectedAmount $selectedAmount");
                  Future.delayed(const Duration(milliseconds: 450)).then((value) async{
                    await context.read<BillingDataController>()
                      .confirmCheckout(paymentModel: currentPayment, storeId: context.read<StoreDataController>().currentStore!.storeId)
                        .then((value) {
                          if(value) {
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const StoreView()), (route) => false);
                          }
                        });
                    
                  });

                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Center(child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidgets().buttonTextHigh(buttonText: 'Confirm', textColor:selectedAmount <= 0 ? Colors.black : Colors.black),
                    // TextWidgets().buttonTextHigh(buttonText: ' ${bill.payableAmount} Tk', textColor: Colors.white),
                  ],
                )),
              ),
            ),
          ),
        ).animate().fade();
      
      },
    );
  }

}