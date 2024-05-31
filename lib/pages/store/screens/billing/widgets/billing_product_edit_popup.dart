import 'dart:typed_data';

import 'package:easypos/common/data/app_regexp.dart';
import 'package:easypos/common/widgets/quantity_textfield.dart';
import 'package:easypos/common/widgets/show_rect_image.dart';
import 'package:easypos/models/billing_product.dart';
import 'package:easypos/pages/store/controller/store_data_controller.dart';
import 'package:easypos/pages/store/screens/billing/controller/billing_data_controller.dart';
import 'package:easypos/utils/app_colors.dart';
import 'package:easypos/utils/app_sizes.dart';
import 'package:easypos/utils/app_textstyles.dart';
import 'package:easypos/utils/dekhao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class BillingProductEditPopup extends StatefulWidget {
  final String billId;
  final BillingProduct billingProduct;
  final Function (double quantity, double discountPercentage) onDone;
  const BillingProductEditPopup({super.key, required this.billingProduct, required this.onDone, required this.billId});

  @override
  State<BillingProductEditPopup> createState() => _BillingProductEditPopupState();
}

class _BillingProductEditPopupState extends State<BillingProductEditPopup> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _quantityInputcontroller = TextEditingController();
  final TextEditingController _discountInputcontroller = TextEditingController();
  Uint8List? productImage;

  @override
  void initState() {
    // TODO: implement initState
    _quantityInputcontroller.text = widget.billingProduct.quantity.toString();
    _discountInputcontroller.text = widget.billingProduct.discountPercentage.toString();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //widget.onDone(double.tryParse(controller.text) ?? 0);
    _quantityInputcontroller.dispose();
    _discountInputcontroller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    productImage = context.read<StoreDataController>().imageIfExist(imageId: widget.billingProduct.productImageId);
    if(productImage == null) {
      dekhao("image is null");
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return CupertinoPageScaffold(
          child: Form(
            key: _formKey,
            child: Container(
              color: Colors.white,
              width: constraints.maxWidth,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Quantity edit', style: AppTextStyle().boldBigSize(context: context),),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green.shade300),
                              boxShadow: const[
                                BoxShadow(color: Color(0x1F000000), blurRadius: 8)
                              ]
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () {
                                  widget.onDone(double.tryParse(_quantityInputcontroller.text) ?? 0, double.tryParse(_discountInputcontroller.text) ?? 0,);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.done_all, color: Colors.green,),
                                      
                                       Padding(
                                        padding: EdgeInsets.only(left: 6.0),
                                        child: Text('Done', style: AppTextStyle().boldNormalSize(context: context),)
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ShowRectImage(image: productImage, height: 120, width: 120, borderRadius: 8,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Text(widget.billingProduct.productName, style: AppTextStyle().boldNormalSize(context: context),),
                                )
                              ],
                            ),
                        
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: SizedBox(
                                height: 60,
                                width: constraints.maxWidth,
                                child: Form(
                                  child: QuantityTextField(
                                    maxLines: 1, 
                                    onChanged: (value){
                                      dekhao("QuantityTextField $value");
                                      if(value != '' && double.tryParse(value)!.isNaN) {
                                        context.read<BillingDataController>().editSoldUnitOfProduct(billId: widget.billId, handTypedSoldUnit: double.tryParse(value) ?? widget.billingProduct.quantity, productId: widget.billingProduct.productId, billigMethod: BillingMethod.itemSelect);
                                      }
                                      
                                    }, 
                                    controller: _quantityInputcontroller, 
                                    hintText: 'Product quantity', 
                                    labelText: 'Quantity', 
                                    validationCheck: (value){
                                      if(value == '') return null;
                                      if(!double.tryParse(value)!.isNaN) {
                                        return "Enter a valid number. (e.g, .145, 20, 23.4, 1003)";
                                      }
                                    }, 
                                    numRegExp: widget.billingProduct.pieceProduct ? integerRegExp() : moneyRegExp(),
                                    onlyInteger: widget.billingProduct.pieceProduct),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: SizedBox(
                                height: 60,
                                width: constraints.maxWidth,
                                child: QuantityTextField(
                                  maxLines: 1, 
                                  onChanged: (value){
                                    dekhao("DiscountTextField $value");
                                    if(value != '' && double.tryParse(value)!.isNaN) {
                                      //context.read<BillingDataController>().editSoldUnitOfProduct(billId: widget.billId, handTypedSoldUnit: double.tryParse(value) ?? widget.billingProduct.quantity, productId: widget.billingProduct.productId, billigMethod: BillingMethod.itemSelect);
                                    }
                                    
                                  }, 
                                  controller: _discountInputcontroller, 
                                  hintText: 'Product Discount', 
                                  labelText: 'Discount(%)', 
                                  validationCheck: (value){
                                    if(value == '') return null;
                                    if(!double.tryParse(value)!.isNaN) {
                                      return "Enter a valid number. (e.g, .145, 20, 23.4, 1003)";
                                    }
                                  }, 
                                  numRegExp: widget.billingProduct.pieceProduct ? integerRegExp() : moneyRegExp(),
                                  onlyInteger: widget.billingProduct.pieceProduct),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: _removeProductFromBill(constraints: constraints),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      
      },
    );
  }

  Widget _removeProductFromBill({required BoxConstraints constraints}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.red.shade100),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const[
          BoxShadow(color: Color(0x1F000000), blurRadius: 8)
        ]
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          splashColor: Colors.red.shade400,
          onTap: () async{
            widget.onDone(0, double.tryParse(_discountInputcontroller.text) ?? 0,);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: AppSizes().header,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    'Remove from billing',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: AppSizes().normalText,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}