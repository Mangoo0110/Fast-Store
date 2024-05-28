import 'package:easypos/data/data_field_names/data_field_names.dart';
import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final String productId;
  final String itemBarcode;
  final String productName;
  final String productDescription;
  final List<String> productCategoryList;
  final String productImageId;
  final double productPrice;
  final double stockCount;
  final double soldFrequency;
  final bool pieceProduct;
  final bool kiloLitreProduct;
  bool ignoreStockOut;
  final Map<double, int> quantityMapFrequency;

  ProductModel(
      {required this.pieceProduct,
      required this.itemBarcode,
      required this.kiloLitreProduct,
      required this.productId,
      required this.productDescription,
      required this.soldFrequency,
      required this.productName,
      required this.productPrice,
      required this.stockCount,
      required this.productCategoryList,
      required this.productImageId,
      required this.quantityMapFrequency,
      required this.ignoreStockOut});

  factory ProductModel.fromMap({required Map<String, dynamic> map}) {
    return ProductModel(
        productId: map[kProductId] ?? '',
        itemBarcode: map[kItemBarcode] ?? '',
        productName: map[kProductName] ?? '',
        productDescription: map[kproductDescription] ?? '',
        productCategoryList: (map[kProductCategoryList] != null)
            ? List<String>.from(map[kProductCategoryList])
            : [],
        productPrice: map[kProductPrice] == null
            ? 0.0
            : double.tryParse(map[kProductPrice].toString()) ?? 0.0,
        stockCount: map[kStockCount] == null
            ? 0
            : double.tryParse(map[kStockCount].toString()) ?? 0.0,
        productImageId: map[kProductImageId] ?? '',
        pieceProduct: map[kpieceProduct] ?? false,
        kiloLitreProduct: map[kkiloLitreProduct] ?? false,
        soldFrequency: map[ksoldFrequency] == null
            ? 0
            : double.tryParse(map[ksoldFrequency].toString()) ?? 0.0,
        quantityMapFrequency: map[kquantityMapFrequency] == null
            ? {}
            : Map<double, int>.from(map[kquantityMapFrequency]),
        ignoreStockOut: map[kignoreStockOut] ?? true);
  }

  toMap() {
    return {
      kProductId: productId,
      kItemBarcode: itemBarcode,
      kProductName: productName,
      kproductDescription: productDescription,
      kProductCategoryList: productCategoryList,
      kProductPrice: productPrice,
      kStockCount: stockCount,
      kProductImageId: productImageId,
      kpieceProduct: pieceProduct,
      kkiloLitreProduct: kiloLitreProduct,
      ksoldFrequency: soldFrequency,
      kquantityMapFrequency: quantityMapFrequency
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        productId,
        itemBarcode,
        productName,
        productDescription,
        productPrice,
        stockCount,
        productImageId,
        pieceProduct,
        kiloLitreProduct,
        soldFrequency,
        quantityMapFrequency
      ];
}
