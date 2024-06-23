// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billing_product.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BillingProductAdapter extends TypeAdapter<BillingProduct> {
  @override
  final int typeId = 4;

  @override
  BillingProduct read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BillingProduct(
      productId: fields[0] as String,
      variantId: fields[1] as String,
      itemBarcode: fields[2] as String,
      billingMethod: fields[5] as BillingMethod,
      discountPercentage: fields[8] as double,
      totalDiscountValue: fields[6] as double,
      productImageId: fields[3] as String,
      productName: fields[4] as String,
      productPrice: fields[7] as double,
      quantity: fields[9] as double,
      totalPrice: fields[11] as double,
      pieceProduct: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, BillingProduct obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.productId)
      ..writeByte(1)
      ..write(obj.variantId)
      ..writeByte(2)
      ..write(obj.itemBarcode)
      ..writeByte(3)
      ..write(obj.productImageId)
      ..writeByte(4)
      ..write(obj.productName)
      ..writeByte(5)
      ..write(obj.billingMethod)
      ..writeByte(6)
      ..write(obj.totalDiscountValue)
      ..writeByte(7)
      ..write(obj.productPrice)
      ..writeByte(8)
      ..write(obj.discountPercentage)
      ..writeByte(9)
      ..write(obj.quantity)
      ..writeByte(10)
      ..write(obj.pieceProduct)
      ..writeByte(11)
      ..write(obj.totalPrice);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BillingProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BillingMethodAdapter extends TypeAdapter<BillingMethod> {
  @override
  final int typeId = 3;

  @override
  BillingMethod read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BillingMethod.calculator;
      case 1:
        return BillingMethod.itemSelect;
      case 2:
        return BillingMethod.scan;
      default:
        return BillingMethod.calculator;
    }
  }

  @override
  void write(BinaryWriter writer, BillingMethod obj) {
    switch (obj) {
      case BillingMethod.calculator:
        writer.writeByte(0);
        break;
      case BillingMethod.itemSelect:
        writer.writeByte(1);
        break;
      case BillingMethod.scan:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BillingMethodAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
