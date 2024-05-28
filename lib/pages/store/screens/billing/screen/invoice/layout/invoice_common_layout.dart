import 'package:easypos/common/data/app_regexp.dart';
import 'package:easypos/common/widgets/name_textfield.dart';
import 'package:easypos/common/widgets/num_textfield.dart';
import 'package:easypos/common/widgets/show_round_image.dart';
import 'package:easypos/models/bill_model.dart';
import 'package:easypos/models/billing_product.dart';
import 'package:easypos/pages/store/controller/store_data_controller.dart';
import 'package:easypos/utils/app_textstyles.dart';
import 'package:easypos/utils/dekhao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class InvoiceCommonLayout extends StatefulWidget {
  final BillModel bill;
  const InvoiceCommonLayout({super.key, required this.bill});

  @override
  State<InvoiceCommonLayout> createState() => _InvoiceCommonLayoutState();
}

class _InvoiceCommonLayoutState extends State<InvoiceCommonLayout> {

  TextEditingController customerNameController = TextEditingController();

  TextEditingController customerContactNoController = TextEditingController();

  TextEditingController receivedMoneyController = TextEditingController();

  double receivedMoney = 0;

  @override
  void initState() {
    // TODO: implement initState
    //receivedMoneyController.text = 
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
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Bill No: 102',
              style: AppTextStyle().boldBigSize(context: context),
            ),
          ),
          body: Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(child: _customerDetails(constraints: constraints)),
                  // _billedProductList(constraints: constraints),
                  // Flexible(
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(top: 4.0),
                  //     child: _money(constraints: constraints),
                  //   ),
                  // ),
            
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
        );
      },
    );
  }

  Widget _customerDetails({required BoxConstraints constraints}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
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
    return Flexible(
      child: SizedBox(
        //height: 150,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: (widget.bill.idMappedBilledProductList.isEmpty) ? 
          const Center(child: Text('No products selected!'))
          :
          Column(
            children: widget.bill.idMappedBilledProductList.entries.map((saleProduct){
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Container(
                  height: 80,
                  width: constraints.maxWidth,
                  decoration: BoxDecoration(
                    color: Colors.green.shade300,
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: _table(context: context, constraints: constraints, billingProduct: saleProduct.value),
                  ),
                ),
              );
            }).toList()
          ),
        ),
      ),
    );
  }
  Widget _table({required BuildContext context, required BoxConstraints constraints, required BillingProduct billingProduct,}) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: const{0: FlexColumnWidth(.48), 1: FlexColumnWidth(.28), 2: FlexColumnWidth(.23),},
      children: [
        TableRow(
          children: [
            Row(
              children: [
                ShowRoundImage(image: context.read<StoreDataController>().imageIfExist(imageId: billingProduct.productImageId), height: 60, width: 60, borderRadius: 5000000,),
                Flexible(
                  child: Text(billingProduct.productName, style: AppTextStyle().normalSize(context: context),),
                ),
              ],
            ),
            Align(alignment: Alignment.center, child: Text("Qty. ${billingProduct.quantity}", style: AppTextStyle().normalSize(context: context),)),
            Align(alignment: Alignment.center, child: Text("${billingProduct.totalPrice.toString()} Tk", style: AppTextStyle().normalSize(context: context),))
          ]
        )
      ],
    );
  }

  Widget _money({required BoxConstraints constraints}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Received money", style: AppTextStyle().normalSize(context: context),),
              SizedBox(
                  height: 75,
                  width: constraints.maxWidth,
                  child: NumTextfield(
                    onTap: () {
                      receivedMoneyController.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: receivedMoneyController.text.length,
                      );
                    },
                    maxLines: 1, 
                    onChanged: (text){
                      dekhao("NumTextfield $text");
                      if(text == '' && double.tryParse(text)!.isNaN) {
                        setState(() {
                          receivedMoney = double.parse(text);
                          widget.bill.totalAmountReceived = receivedMoney;
                          widget.bill.dueAmount = widget.bill.totalAmountReceived - widget.bill.payableAmount;
                        });
                      }
                    }, 
                    controller: customerNameController, 
                    hintText: "Type customer's name", 
                    labelText: "Customer's name", 
                    validationCheck: (text){}, 
                    onlyInteger: false, 
                    numRegExp: moneyRegExp(),),),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total", style: AppTextStyle().normalSize(context: context),),
              SizedBox(
                  height: 75,
                  child: Text(widget.bill.payableAmount.toString(), style: AppTextStyle().normalSize(context: context),)),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Due", style: AppTextStyle().normalSize(context: context),),
              SizedBox(
                  height: 75,
                  child: Text(widget.bill.dueAmount.toString(), style: AppTextStyle().normalSize(context: context),)),
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