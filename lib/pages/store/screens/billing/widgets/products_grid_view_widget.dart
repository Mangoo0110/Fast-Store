import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:easypos/common/widgets/show_rect_image.dart';
import 'package:easypos/models/billing_product.dart';
import 'package:easypos/models/product_model.dart';
import 'package:easypos/pages/store/controller/store_data_controller.dart';
import 'package:easypos/pages/store/screens/billing/controller/billing_data_controller.dart';
import 'package:easypos/pages/store/screens/billing/widgets/billing_product_edit_popup.dart';
import 'package:easypos/utils/app_textstyles.dart';
import 'package:easypos/utils/dekhao.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductGridViewWiget extends StatefulWidget {
  final String billId;
  final List<ProductModel> productList;
  const ProductGridViewWiget({super.key, required this.billId, required this.productList});

  @override
  State<ProductGridViewWiget> createState() => _ProductGridViewWigetState();
}

class _ProductGridViewWigetState extends State<ProductGridViewWiget> {
  @override
  Widget build(BuildContext context) {
    if(widget.productList.isEmpty) {
      return Text('0 products', style: AppTextStyle().greyBoldNormalSize(context: context),);
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          itemCount: widget.productList.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 175,
            childAspectRatio: 4 / 5,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ), 
          itemBuilder:(context, index) {
            ProductModel thisProduct = widget.productList[index];
            Uint8List? thisProductImage = context.watch<StoreDataController>().idMappedImages[thisProduct.productImageId];
        
            bool thisProductIsSelected = false; 
            double selectedQuantity = 0;
            if(context.read<BillingDataController>().inStoreBillQueue.containsKey(widget.billId)) {
              thisProductIsSelected = context.read<BillingDataController>().inStoreBillQueue[widget.billId]!.idMappedBilledProductList.containsKey(thisProduct.productId);
              if(thisProductIsSelected) {
                selectedQuantity = context.read<BillingDataController>().inStoreBillQueue[widget.billId]!.idMappedBilledProductList[thisProduct.productId]!.quantity;
              }
            }
            
            return Container(
              decoration: BoxDecoration(
                color: thisProductIsSelected ? Colors.green.shade200 : Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(color: Color(0x1F000000), blurRadius: 5)
                ]
                //border: Border.all(color: Colors.black)
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    context.read<BillingDataController>().addBillingProduct(billId: widget.billId, product: thisProduct, addingUnit: 1, discountPercentage: 0, billigMethod: BillingMethod.itemSelect);
                    setState(() {
                      
                    });
                  },
        
                  onLongPress: () {
                    BillingProduct billingProduct = BillingProduct(
                      productId: thisProduct.productId, 
                      itemBarcode: thisProduct.itemBarcode, 
                      billingMethod: BillingMethod.itemSelect, 
                      discountPercentage: 0, 
                      productImageId: thisProduct.productImageId, 
                      productName: thisProduct.productName, 
                      productPrice: thisProduct.productPrice, 
                      quantity: selectedQuantity, 
                      totalPrice: 0, pieceProduct: thisProduct.pieceProduct);
                    if(thisProductIsSelected) {
                      billingProduct = context.read<BillingDataController>().inStoreBillQueue[widget.billId]!.idMappedBilledProductList[thisProduct.productId]!;
                    }
                    showModalBottomSheet(
                      context: context, 
                      builder:(context) => BillingProductEditPopup(
                        billId: widget.billId,
                        billingProduct: billingProduct,
                        onDone: (quantity, discountPercentage) {
                          dekhao("BillingProductEditPopup ${quantity.toString()}");
                          if(!thisProductIsSelected) {
                            context.read<BillingDataController>().addBillingProduct(billId: widget.billId, product: thisProduct, addingUnit: 1, discountPercentage: discountPercentage, billigMethod: BillingMethod.itemSelect);
                          }
                          context.read<BillingDataController>().productDiscount(billId: widget.billId, discountPercentage: discountPercentage, productId: thisProduct.productId);
                          context.read<BillingDataController>().editSoldUnitOfProduct(billId: widget.billId, handTypedSoldUnit: quantity, productId: billingProduct.productId, billigMethod: BillingMethod.itemSelect);
                          Navigator.pop(context);
                          setState(() {
                            
                          });
                        }));
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ShowRectImage(
                              image: thisProductImage, 
                              height: constraints.maxWidth / (constraints.maxWidth / 175).ceil() * (.6), 
                              width: constraints.maxWidth,
                              borderRadius: 8,
                              ),
                          ),
                  
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Text(
                              thisProduct.productName, 
                              style: AppTextStyle().boldSmallSize(context: context)
                            ),
                          ),
                        ],
                      ),
        
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: Colors.black)
                                      //color: Colors.white,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
                                      child: Center(
                                        child: Text(
                                          selectedQuantity.toString(), 
                                          style: AppTextStyle().smallSize(context: context)
                                        ),
                                      ),
                                    ),
                                  ),
                                  DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(4),
                                    dashPattern: const [3, 2],
                                    color: Colors.black,
                                    strokeWidth: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        //color: Colors.transparent
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1),
                                        child: Center(
                                          child: Text(
                                            "${thisProduct.productPrice}", 
                                            style: AppTextStyle().smallSize(context: context)
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
    );
  }
}