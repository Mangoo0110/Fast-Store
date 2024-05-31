import 'package:easypos/common/data/app_regexp.dart';
import 'package:easypos/common/widgets/name_textfield.dart';
import 'package:easypos/common/widgets/num_textfield.dart';
import 'package:easypos/common/widgets/show_round_image.dart';
import 'package:easypos/models/bill_model.dart';
import 'package:easypos/models/billing_product.dart';
import 'package:easypos/pages/store/controller/store_data_controller.dart';
import 'package:easypos/pages/store/screens/billing/controller/billing_data_controller.dart';
import 'package:easypos/pages/store/screens/billing/widgets/billed_product_list_widget.dart';
import 'package:easypos/pages/store/screens/billing/widgets/invoice_sections_widget.dart';
import 'package:easypos/utils/app_colors.dart';
import 'package:easypos/utils/app_sizes.dart';
import 'package:easypos/utils/app_textstyles.dart';
import 'package:easypos/utils/dekhao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class InvoiceLayout extends StatefulWidget {
  final BillModel bill;
  const InvoiceLayout({super.key, required this.bill});

  @override
  State<InvoiceLayout> createState() => _InvoiceLayoutState();
}

class _InvoiceLayoutState extends State<InvoiceLayout> {

  final List<String> sectionNameList = ['Customer Info', 'Payable Info', 'Billed Products'];
  final List<GlobalKey> sectionKeyList = [GlobalKey(), GlobalKey(), GlobalKey()];

  TextEditingController customerNameController = TextEditingController();

  TextEditingController customerContactNoController = TextEditingController();

  TextEditingController receivedMoneyController = TextEditingController();

  double receivedMoney = 0;

  void scrollToSection({required GlobalKey key}) {
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCirc);
  }

  @override
  void initState() {
    // TODO: implement initState
    receivedMoney = widget.bill.totalAmountReceived;
    if(receivedMoney <= 0) {
      receivedMoney = widget.bill.payableAmount;
    }
    receivedMoneyController.text = receivedMoney.toString();
    receivedMoneyController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: receivedMoneyController.text.length,
    );
    //receivedMoneyController.selection.extendTo(position)
    
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    customerContactNoController.dispose();
    customerNameController.dispose();
    receivedMoneyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BillModel bill = context.watch<BillingDataController>().inStoreBillQueue[widget.bill.billId]!;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Instore Bill',
              style: AppTextStyle().boldBigSize(context: context),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              //mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 40,
                  width: constraints.maxWidth,
                  child: InvoiceSectionWidget(
                    sectionNameList: sectionNameList, 
                    onTap:(selectedSectionIndex) {
                      scrollToSection(key: sectionKeyList[selectedSectionIndex]);
                    }, 
                    initialIndex: 0
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Container(
                            key: sectionKeyList[0], 
                            child: _customerDetails(constraints: constraints))),
                        
                        Flexible(
                          child: Container(
                            key: sectionKeyList[1],
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: _money(constraints: constraints, bill: bill),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Container(
                            key: sectionKeyList[2], 
                            child: _billedProductList(constraints: constraints) 
                          ),
                        ),
                        // Flexible(
                        //   child: Padding(
                        //     padding: const EdgeInsets.only(top: 4.0),
                        //     child: _saveEditButtons(constraints: constraints),
                        //   ),
                        // ),
                      ],
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

  Widget _customerDetails({required BoxConstraints constraints}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 75,
            width: constraints.maxWidth,
            child: NameTextfield(
              maxLines: 1, 
              onChanged: (text){}, 
              controller: customerNameController, 
              hintText: "Type customer's name", 
              labelText: "Customer's name", 
              validationCheck: (text){}),),
          
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: SizedBox(
              height: 75,
              width: constraints.maxWidth,
              child: NameTextfield(
                maxLines: 1, 
                onChanged: (text){}, 
                controller: customerNameController, 
                hintText: "Type customer's contact no", 
                labelText: "Customer's contact no", 
                validationCheck: (text){}),),
          ),
          
        ],
      ),
    );
  }

  Widget _billedProductList({required BoxConstraints constraints}) {
    return SizedBox(
      //height: 150,
      child: BilledProductListWidget(
        billedProductList: context.read<BillingDataController>().inStoreBillQueue[widget.bill.billId]!.idMappedBilledProductList.entries.map((e) => e.value).toList(), 
        billId: widget.bill.billId,)
    );
  }

  Widget _money({required BoxConstraints constraints, required BillModel bill}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: constraints.maxWidth * .7,
                child: Text("Received money", style: AppTextStyle().normalSize(context: context),)),
              Flexible(
                fit: FlexFit.tight,
                child: SizedBox(
                    height: 50,
                    //width: constraints.maxWidth,
                    child: NumTextfield(
                      onTap: () {
                        
                      },
                      maxLines: 1, 
                      onChanged: (text){
                        if(text.isEmpty)text = '0';
                        dekhao("NumTextfield $text");
                        if(text != '' && RegExp(r'^\d+(?:\.\d+)?$').hasMatch(text)) {
                          dekhao("NumTextfield $text");
                          receivedMoney = double.parse(text);
                          context.read<BillingDataController>().editReceivedMoneyOfBill(receivedMoney: receivedMoney, billId: widget.bill.billId);
                        }
                      }, 
                      controller: receivedMoneyController, 
                      hintText: "", 
                      labelText: "", 
                      validationCheck: (text){}, 
                      onlyInteger: false, 
                      numRegExp: moneyRegExp(),),),
              ),
              Text(" Tk", style: AppTextStyle().normalSize(context: context),),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total", style: AppTextStyle().normalSize(context: context),),
              Row(
                children: [
                  Text(bill.payableAmount.toString(), style: AppTextStyle().normalSize(context: context),),
                  Text(" Tk", style: AppTextStyle().normalSize(context: context),),
                ],
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(receivedMoney - bill.payableAmount < 0 ? "Due" : "Change", style: AppTextStyle().normalSize(context: context),),
              Row(
                children: [
                  Text((receivedMoney - bill.payableAmount).abs().toString(), style: AppTextStyle().normalSize(context: context),),
                  Text(" Tk", style: AppTextStyle().normalSize(context: context),),
                ],
              ),

            ],
          ),
        ),
      ],
    );
  }
  Widget _saveEditButtons({required BoxConstraints constraints}) {
    return Row(
      children: [
        Material(
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Save"
              ),
            ),
          ),
        ),
        Material(
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Cancel"
              ),
            ),
          ),
        )
      ],
    );
  }
}