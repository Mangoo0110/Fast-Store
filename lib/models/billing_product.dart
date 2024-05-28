import 'package:easypos/data/data_field_names/data_field_names.dart';

class BillingProduct {
  final String productId;
  final String itemBarcode;
  final String productImageId;
  final String productName;
  double productPrice;
  double discountPercentage;
  double quantity;
  final bool pieceProduct;
  double totalPrice;

  BillingProduct({required this.productId, required this.itemBarcode, required this.discountPercentage, required this.productImageId, required this.productName, required this.productPrice, required this.quantity, required this.totalPrice, required this.pieceProduct, });
  
  factory BillingProduct.fromMap({required Map<String, dynamic> map}) {
    return BillingProduct(
      productId: map[kProductId] ?? '',
      itemBarcode: map[kItemBarcode] ?? '',
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
      kProductName : productName,
      kProductPrice: productPrice,
      kquantity : quantity,
      kTotalPrice : totalPrice,
      kpieceProduct: pieceProduct,
    };
  }
}