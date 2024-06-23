import 'package:easypos/data/data_field_names/data_field_names.dart';
import 'package:equatable/equatable.dart';

class ProductVariantModel extends Equatable {
  final String variantId;
  final String variantName;
  final double variantPrice;
  final double productionCost;
  final double discountPercentage;
  final double stockCount;

  const ProductVariantModel(
      {
      required this.variantId,
      required this.variantName,
      required this.variantPrice,
      required this.productionCost,
      required this.discountPercentage,
      required this.stockCount,});

  factory ProductVariantModel.fromMap({required Map<String, dynamic> map}) {
    return ProductVariantModel(
        variantId: map[kvariantId] ?? '',
        variantName: map[kProductName] ?? '',
        variantPrice: map[kProductPrice] == null
            ? 0.0
            : double.tryParse(map[kProductPrice].toString()) ?? 0.0,
        productionCost: map[kProductionCost] == null
            ? 0.0
            : double.tryParse(map[kProductPrice].toString()) ?? 0.0,
        discountPercentage: map[kdiscountPercentage] ?? 0.0,
        stockCount: map[kStockCount] == null
            ? 0
            : double.tryParse(map[kStockCount].toString()) ?? 0.0,);
  }

   Map<String, dynamic> toMap() {
    return {
      kProductName: variantName,
      kProductPrice: variantPrice,
      kProductionCost: productionCost,
      kdiscountPercentage: discountPercentage,
      kStockCount: stockCount,
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        variantId,
        variantName,
        variantPrice,
        stockCount,
      ];
}
