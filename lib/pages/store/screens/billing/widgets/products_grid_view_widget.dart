import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:easypos/common/widgets/image_related/show_rect_image.dart';
import 'package:easypos/common/widgets/text_widgets.dart';
import 'package:easypos/models/billing_product.dart';
import 'package:easypos/models/product_model.dart';
import 'package:easypos/pages/store/controller/store_data_controller.dart';
import 'package:easypos/pages/store/screens/billing/controller/billing_data_controller.dart';
import 'package:easypos/pages/store/screens/billing/widgets/billing_product_edit_popup.dart';
import 'package:easypos/utils/app_textstyles.dart';
import 'package:easypos/utils/dekhao.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ProductGridViewWiget extends StatefulWidget {
  final List<ProductModel> productList;
  const ProductGridViewWiget({super.key, required this.productList});

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
            if(context.read<BillingDataController>().currentBill != null) {
              thisProductIsSelected = context.read<BillingDataController>().currentBill!.idMappedBilledProductList.containsKey(thisProduct.productId);
              if(thisProductIsSelected) {
                selectedQuantity = context.read<BillingDataController>().currentBill!.idMappedBilledProductList[thisProduct.productId]!.quantity;
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
                    context.read<BillingDataController>().addBillingProduct(product: thisProduct, addingUnit: 1, billigMethod: BillingMethod.itemSelect);
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
                      totalPrice: 0, pieceProduct: thisProduct.pieceProduct, totalDiscountValue: 0, variantId: thisProduct.productId);
                    if(thisProductIsSelected) {
                      billingProduct = context.read<BillingDataController>().currentBill!.idMappedBilledProductList[thisProduct.productId]!;
                    }
                    showModalBottomSheet(
                      context: context, 
                      builder:(context) => BillingProductEditPopup(
                        billingProduct: billingProduct,
                        onDone: (quantity, discountPercentage) {
                          dekhao("BillingProductEditPopup ${quantity.toString()}");
                          if(!thisProductIsSelected) {
                            context.read<BillingDataController>().addBillingProduct( product: thisProduct, addingUnit: 1, billigMethod: BillingMethod.itemSelect);
                          }
                          context.read<BillingDataController>().productDiscount(discountPercentage: discountPercentage, productId: thisProduct.productId);
                          context.read<BillingDataController>().editSoldUnitOfProduct( handTypedSoldUnit: quantity, productId: billingProduct.productId, billigMethod: BillingMethod.itemSelect);
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
        
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: _priceQuantity(selectedQuantity: selectedQuantity, price: thisProduct.productPrice),
                        )
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

  Widget _priceQuantity({required double selectedQuantity, required double price}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidgets().buttonText(buttonText: 'Price: ', textColor: Colors.grey),
                TextWidgets().buttonText(buttonText: price.toString(), textColor: Colors.black),
              ],
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidgets().buttonText(buttonText: 'Qty: ', textColor: Colors.grey),
                    Flexible(child: TextWidgets().buttonText(buttonText: selectedQuantity.toString(), textColor: Colors.black)),
                  ],
                ),
              ),
            )
          ],
        );            
      },
    );
  }
}