import 'package:easypos/common/widgets/buttons/button_collection.dart';
import 'package:easypos/common/widgets/textfields/description_textfield.dart';
import 'package:easypos/common/widgets/text_widgets.dart';
import 'package:easypos/models/bill_model.dart';
import 'package:easypos/pages/store/screens/billing/controller/billing_data_controller.dart';
import 'package:easypos/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CustomerDetailsPopup extends StatefulWidget {
  final String currentBillId;
  const CustomerDetailsPopup({super.key, required this.currentBillId});

  @override
  State<CustomerDetailsPopup> createState() => _CustomerDetailsPopupState();
}

class _CustomerDetailsPopupState extends State<CustomerDetailsPopup> {

  BillModel? currentBill;

  late DateTime deliveryTime;

  TextEditingController customerNameEditingController = TextEditingController();
  TextEditingController customerContNoEditingController = TextEditingController();
  TextEditingController deliveryAddressEditingController = TextEditingController();
  TextEditingController searchEditingController = TextEditingController();

  //functions ::
  getAndSyncBillData() {

  }

  Future<void> _showDatePicker() async{
    await showDatePicker(
      context: context,
      initialDate: DateTime.now(), 
      firstDate: DateTime.now(), 
      lastDate: DateTime.now().add(const Duration(days: 365))
    ).then((pickedDate) async{
      if(pickedDate != null) {
        deliveryTime = pickedDate;
        await showTimePicker(
          context: context, 
          initialTime: TimeOfDay.now()
        ).then((pickedTime) {
          if(pickedTime != null) {
            deliveryTime = DateTime(deliveryTime.year, deliveryTime.month, deliveryTime.day, pickedTime.hour, pickedTime.minute);
          }
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    deliveryTime = DateTime.now();
    //deliveryDate = DateTime.now();
    currentBill = context.read<BillingDataController>().currentBill;

    if(currentBill != null) {
      customerNameEditingController.text = currentBill!.customerName;
      customerContNoEditingController.text = currentBill!.customerContactNo;
      deliveryAddressEditingController.text = currentBill!.deliveryInfo!.deliveryAddress;
    }

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    currentBill = context.watch<BillingDataController>().currentBill;
    return LayoutBuilder(
      builder: (context, constraints) {
        return CupertinoPageScaffold(
          child: Container(
            color: Colors.white,
            width: constraints.maxWidth,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Container(
                    width: 100,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.4),
                      borderRadius: BorderRadius.circular(8)
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(4, 26, 4, 5),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 65,
                          width: constraints.maxWidth,
                          child: popupHeader()),
                        
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: SizedBox(
                                      height: 60,
                                      width: constraints.maxWidth,
                                      child: customerNameField()),
                                  ),
                                  
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: SizedBox(
                                      height: 60,
                                      width: constraints.maxWidth,
                                      child: customerContactNoField()),
                                  ),
                                  currentBill!.billType != BillType.delivery ?
                                  Container()
                                  :
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 15.0),
                                        child: SizedBox(
                                          height: 65,
                                          width: constraints.maxWidth,
                                          child: deliveryAddressField()),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 15.0),
                                        child: SizedBox(
                                          height: 65,
                                          width: constraints.maxWidth,
                                          child: deliveryDateTime()),
                                      ),
                                    ],
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: popupSaveButton()
                                  ),
                                  
                                ],
                              ),
                            ),
                          ),
                        ),
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


   Widget customerNameField() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return DescriptionTextfield(
          maxLines: 1, 
          onChanged:(text) {
            
          }, 
          controller: customerNameEditingController, 
          hintText: 'Enter the name of the customer', 
          labelText: 'Customer Name', 
          );
      },
    );
  }

  Widget customerContactNoField() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return DescriptionTextfield(
          maxLines: 1, 
          onChanged:(text) {
            
          }, 
          controller: customerContNoEditingController, 
          hintText: 'Enter the contact number of the customer', 
          labelText: 'Contact No', 
          );
      },
    );
  }

  Widget deliveryAddressField() {
    if(currentBill!.billType != BillType.delivery) {
      return Container();
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return DescriptionTextfield(
          maxLines: 3, 
          onChanged:(text) {
            
          }, 
          controller: deliveryAddressEditingController, 
          hintText: 'Enter the delivery address details', 
          labelText: 'Delivery Address', 
        );
      },
    );
  }

  Widget deliveryDateTime() {
    if(currentBill!.billType != BillType.delivery) {
      return Container();
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [
            TextWidgets().highLightText(text: 'Delivery Time : ', textColor: Colors.black.withOpacity(.8)), 
            TextWidgets().highLightText(text: DateFormat.yMMMEd().format(deliveryTime.toLocal()), textColor:  AppColors().billingAccentColor(billType: currentBill!.billType)),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () async{
                  await _showDatePicker().then((value) {
                  });
                },
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.edit_calendar, size: 30, color: AppColors().billingAccentColor(billType: currentBill!.billType)),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget searchCustomer() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [
            SizedBox(
              width: constraints.maxWidth * .7,
              child: DescriptionTextfield(
                maxLines: 3, 
                onChanged:(text) {
                  
                }, 
                controller: searchEditingController, 
                hintText: "Enter customer contact no and tap 'Search'", 
                labelText: '', 
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: ButtonCollection().sizedButton(
                buttonHeight: constraints.maxHeight,
                buttonWidth: constraints.maxWidth * 3 - 8,
                buttonText: 'Search', 
                wantShadow: true, 
                buttonColor: Colors.white, 
                textColor: Colors.black,
                onButtonTap:() {
                  
                },)
            )
          ],
        );
      },
    );
  }

  Widget popupSaveButton() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ButtonCollection().sizedSaveButton(
          buttonHeight: 55, buttonWidth: constraints.maxWidth, 
          wantShadow: true, 
          buttonColor:  AppColors().billingAccentColor(billType: currentBill!.billType), 
          textColor: Colors.white, 
          onButtonTap: (){
            context.read<BillingDataController>().editCustomerDetailsOfBill(
              customerName: customerNameEditingController.text.trim(), 
              customerContactNo: customerContNoEditingController.text.trim(), 
              deliveryAddress: deliveryAddressEditingController.text.trim(), 
              deliveryTime: deliveryTime);
            
            Navigator.pop(context);
          });
      },
    );
  }

  Widget popupHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return TextWidgets().popupHeader(headerText: 'Customer Details', textColor: Colors.black.withOpacity(.7));
      },
    );
  }

}