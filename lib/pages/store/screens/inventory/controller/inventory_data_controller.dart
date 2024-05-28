import 'package:easypos/models/billing_product.dart';
import 'package:easypos/models/product_model.dart';
import 'package:flutter/material.dart';

class InventoryDataController extends ChangeNotifier {

  Map<String, BillingProduct> _longpressSelectedBillingProductMap = {};

  Map<String, BillingProduct> get longpressSelectedBillingProductMap => _longpressSelectedBillingProductMap;


  // addOrRemoveInQuickBillingProduct({required ProductModel product, required double discountPercentage}) {
  //   if(_longpressSelectedBillingProductMap.containsKey(product.productId)) {
  //     _longpressSelectedBillingProductMap.remove(product.productId);
  //     notifyListeners();
  //   } else{
  //     final billingProduct = 
  //       BillingProduct(
  //         productName: product.productName, 
  //         itemBarcode: '',
  //         productImageId: product.productImageId,
  //         quantity: 1, 
  //         discountPercentage: discountPercentage,
  //         totalPrice: product.productPrice, 
  //         productId: product.productId,
  //         pieceProduct: product.pieceProduct, productPrice: product.productPrice,
  //       );
  //       _longpressSelectedBillingProductMap[product.productId] = billingProduct;
  //       notifyListeners();
  //   }
  // }

  emptyLongPressedBillingProductMap(){
    _longpressSelectedBillingProductMap = {};
    notifyListeners();
  }

  Future<void> createOrUpdateQuickBillingProducts() async{
    
  }
}