import 'package:easypos/data/data_field_names/data_field_names.dart';
import 'package:hive/hive.dart';


part 'billing_product.g.dart'; // Generated file name


@HiveType(typeId: 3) // Annotate with HiveType and specify a typeId
enum BillingMethod {
  @HiveField(0)
  calculator,

  @HiveField(1)
  itemSelect,

  @HiveField(2)
  scan,
}

@HiveType(typeId: 4) // Annotate with HiveType and specify a typeId
class BillingProduct {
  @HiveField(0) // Annotate fields that need to be serialized with HiveField
  final String productId;

  @HiveField(1)
  final String variantId;

  @HiveField(2)
  final String itemBarcode;

  @HiveField(3)
  final String productImageId;

  @HiveField(4)
  final String productName;

  @HiveField(5)
  final BillingMethod billingMethod;

  @HiveField(6)
  double totalDiscountValue;

  @HiveField(7)
  double productPrice;

  @HiveField(8)
  double discountPercentage;

  @HiveField(9)
  double quantity;

  @HiveField(10)
  final bool pieceProduct;

  @HiveField(11)
  double totalPrice;

  BillingProduct({
    required this.productId, 
    required this.variantId,
    required this.itemBarcode, 
    required this.billingMethod, 
    required this.discountPercentage, 
    required this.totalDiscountValue,
    required this.productImageId, 
    required this.productName, 
    required this.productPrice, 
    required this.quantity, 
    required this.totalPrice, 
    required this.pieceProduct, });
  
  factory BillingProduct.fromMap({required Map<String, dynamic> map}) {
    String variantIdIfNull = map[kProductId] ?? '';
    return BillingProduct(
      productId: map[kProductId] ?? '',
      variantId: map[kvariantId] ?? variantIdIfNull,
      itemBarcode: map[kItemBarcode] ?? '',
      billingMethod: map[kBillingMethod].toString() ==  BillingMethod.calculator.name ? BillingMethod.calculator : BillingMethod.itemSelect,
      productImageId: map[kProductImageId] ?? '',
      productName: map[kProductName], 
      productPrice: map[kProductPrice],
      totalDiscountValue: map[ktotalDiscountValue],
      discountPercentage: map[kdiscountPercentage] ?? 0.0,
      quantity: map[kquantity] ?? 0.0, 
      totalPrice: map[kTotalPrice] ?? 0.0, 
      pieceProduct: map[kpieceProduct] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      kProductId: productId,
      kvariantId: variantId,
      kItemBarcode: itemBarcode,
      kBillingMethod: billingMethod.name,
      kProductName : productName,
      kProductPrice: productPrice,
      kquantity : quantity,
      kTotalPrice : totalPrice,
      kpieceProduct: pieceProduct,
      kdiscountPercentage: discountPercentage,
      ktotalDiscountValue: totalDiscountValue
    };
  }
}