import 'package:easypos/data/data_field_names/data_field_names.dart';
enum BillingMethod {calculator, itemSelect}
class BillingProduct {
  final String productId;
  final String itemBarcode;
  final String productImageId;
  final String productName;
  final BillingMethod billingMethod;
  double productPrice;
  double discountPercentage;
  double quantity;
  final bool pieceProduct;
  double totalPrice;

  BillingProduct({required this.productId, required this.itemBarcode, required this.billingMethod, required this.discountPercentage, required this.productImageId, required this.productName, required this.productPrice, required this.quantity, required this.totalPrice, required this.pieceProduct, });
  
  factory BillingProduct.fromMap({required Map<String, dynamic> map}) {
    return BillingProduct(
      productId: map[kProductId] ?? '',
      itemBarcode: map[kItemBarcode] ?? '',
      billingMethod: map[kBillingMethod].toString() ==  BillingMethod.calculator.name ? BillingMethod.calculator : BillingMethod.itemSelect,
      productImageId: map[kProductImageId] ?? '',
      productName: map[kProductName], 
      productPrice: map[kProductPrice],
      discountPercentage: map[kdiscountPercentage] ?? 0.0,
      quantity: map[kquantity] ?? 0.0, 
      totalPrice: map[kTotalPrice] ?? 0.0, 
      pieceProduct: map[kpieceProduct] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      kProductId: productId,
      kItemBarcode: itemBarcode,
      kBillingMethod: billingMethod.name,
      kProductName : productName,
      kProductPrice: productPrice,
      kquantity : quantity,
      kTotalPrice : totalPrice,
      kpieceProduct: pieceProduct,
    };
  }
}