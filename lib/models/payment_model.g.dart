// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PaymentModelAdapter extends TypeAdapter<PaymentModel> {
  @override
  final int typeId = 8;

  @override
  PaymentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PaymentModel(
      transactionId: fields[0] as String,
      paymentMethod: fields[1] as PaymentMethod,
      paidAmount: fields[2] as double,
      transactionAt: fields[3] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, PaymentModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.transactionId)
      ..writeByte(1)
      ..write(obj.paymentMethod)
      ..writeByte(2)
      ..write(obj.paidAmount)
      ..writeByte(3)
      ..write(obj.transactionAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PaymentMethodAdapter extends TypeAdapter<PaymentMethod> {
  @override
  final int typeId = 7;

  @override
  PaymentMethod read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PaymentMethod.cash;
      case 1:
        return PaymentMethod.visa;
      case 2:
        return PaymentMethod.mastercard;
      case 3:
        return PaymentMethod.bkash;
      case 4:
        return PaymentMethod.nogod;
      case 5:
        return PaymentMethod.card;
      case 6:
        return PaymentMethod.mobileBanking;
      case 7:
        return PaymentMethod.other;
      case 8:
        return PaymentMethod.onHouse;
      default:
        return PaymentMethod.cash;
    }
  }

  @override
  void write(BinaryWriter writer, PaymentMethod obj) {
    switch (obj) {
      case PaymentMethod.cash:
        writer.writeByte(0);
        break;
      case PaymentMethod.visa:
        writer.writeByte(1);
        break;
      case PaymentMethod.mastercard:
        writer.writeByte(2);
        break;
      case PaymentMethod.bkash:
        writer.writeByte(3);
        break;
      case PaymentMethod.nogod:
        writer.writeByte(4);
        break;
      case PaymentMethod.card:
        writer.writeByte(5);
        break;
      case PaymentMethod.mobileBanking:
        writer.writeByte(6);
        break;
      case PaymentMethod.other:
        writer.writeByte(7);
        break;
      case PaymentMethod.onHouse:
        writer.writeByte(8);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentMethodAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
