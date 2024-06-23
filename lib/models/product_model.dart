import 'package:easypos/data/data_field_names/data_field_names.dart';
import 'package:easypos/models/product_variant_model.dart';
import 'package:equatable/equatable.dart';

class ProductModel extends Equatable{
  String productId;
  String itemBarcode;
  String productName;
  String productDescription;
  List<String> productCategoryList;
  String productImageId;
  double productPrice;
  double productionCost;
  double discountPercentage;
  double stockCount;
  double soldFrequency;
  bool pieceProduct;
  bool kiloLitreProduct;
  bool ignoreStockOut;
  List<ProductVariantModel> variantList;
  Map<double, int> quantityMapFrequency;

  ProductModel(
      {required this.pieceProduct,
      required this.itemBarcode,
      required this.kiloLitreProduct,
      required this.productId,
      required this.productDescription,
      required this.soldFrequency,
      required this.productName,
      required this.productPrice,
      required this.productionCost,
      required this.discountPercentage,
      required this.stockCount,
      required this.productCategoryList,
      required this.productImageId,
      required this.quantityMapFrequency,
      required this.ignoreStockOut,
      required this.variantList});
  factory ProductModel.fromMap({required Map<String, dynamic> map}) {

    List<Map<String, dynamic>> variantListRaw = map[kvariantList] == null ? [] : List<Map<String, dynamic>>.from(map[kvariantList]);
    List<ProductVariantModel> variantListData = [];
    for(Map<String, dynamic> variant in variantListRaw) {
      variantListData.add(ProductVariantModel.fromMap(map: variant));
    }
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
        productionCost: map[kProductionCost] == null
            ? 0.0
            : double.tryParse(map[kProductPrice].toString()) ?? 0.0,
        discountPercentage: map[kdiscountPercentage] ?? 0.0,
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
        ignoreStockOut: map[kignoreStockOut] ?? true,
        variantList: variantListData
    );
  }

  toMap() {
    List< Map<String, dynamic>> variantListRaw = variantList.map((variant) => variant.toMap()).toList();
    return {
      kProductId: productId,
      kItemBarcode: itemBarcode,
      kProductName: productName,
      kkiloLitreProduct: kiloLitreProduct,
      kproductDescription: productDescription,
      kProductCategoryList: productCategoryList,
      kProductPrice: productPrice,
      kProductionCost: productionCost,
      kdiscountPercentage: discountPercentage,
      kStockCount: stockCount,
      kProductImageId: productImageId,
      kpieceProduct: pieceProduct,
      ksoldFrequency: soldFrequency,
      kquantityMapFrequency: quantityMapFrequency,
      kignoreStockOut: ignoreStockOut,
      kvariantList: variantListRaw
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
        quantityMapFrequency,
        variantList,
      ];
}
