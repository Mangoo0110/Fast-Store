// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BillModelAdapter extends TypeAdapter<BillModel> {
  @override
  final int typeId = 10;

  @override
  BillModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BillModel(
      billId: fields[0] as String,
      localBillNo: fields[1] as String,
      billType: fields[2] as BillType,
      billerName: fields[3] as String,
      billerId: fields[4] as String,
      customerName: fields[5] as String,
      customerContactNo: fields[6] as String,
      idMappedBilledProductList:
          (fields[7] as Map).cast<String, BillingProduct>(),
      subTotal: fields[8] as double,
      taxNameMapPercentage: (fields[11] as Map).cast<String, double>(),
      discountPercentage: fields[9] as double,
      discountValue: fields[10] as double,
      payableAmount: fields[12] as double,
      totalReceivedAmount: fields[14] as double,
      paymentList: (fields[13] as List).cast<PaymentModel>(),
      dueAmount: fields[15] as double,
      billedAt: fields[16] as DateTime?,
      deliveryCharge: fields[18] as double,
      deliveryInfo: fields[17] as DeliveryInfoModel?,
      onlineStatus: fields[19] as OnlineStatus,
      billingStatus: fields[20] as BillingStatus,
    );
  }

  @override
  void write(BinaryWriter writer, BillModel obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.billId)
      ..writeByte(1)
      ..write(obj.localBillNo)
      ..writeByte(2)
      ..write(obj.billType)
      ..writeByte(3)
      ..write(obj.billerName)
      ..writeByte(4)
      ..write(obj.billerId)
      ..writeByte(5)
      ..write(obj.customerName)
      ..writeByte(6)
      ..write(obj.customerContactNo)
      ..writeByte(7)
      ..write(obj.idMappedBilledProductList)
      ..writeByte(8)
      ..write(obj.subTotal)
      ..writeByte(9)
      ..write(obj.discountPercentage)
      ..writeByte(10)
      ..write(obj.discountValue)
      ..writeByte(11)
      ..write(obj.taxNameMapPercentage)
      ..writeByte(12)
      ..write(obj.payableAmount)
      ..writeByte(13)
      ..write(obj.paymentList)
      ..writeByte(14)
      ..write(obj.totalReceivedAmount)
      ..writeByte(15)
      ..write(obj.dueAmount)
      ..writeByte(16)
      ..write(obj.billedAt)
      ..writeByte(17)
      ..write(obj.deliveryInfo)
      ..writeByte(18)
      ..write(obj.deliveryCharge)
      ..writeByte(19)
      ..write(obj.onlineStatus)
      ..writeByte(20)
      ..write(obj.billingStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BillModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BillTypeAdapter extends TypeAdapter<BillType> {
  @override
  final int typeId = 11;

  @override
  BillType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BillType.walking;
      case 1:
        return BillType.delivery;
      case 2:
        return BillType.inHouse;
      default:
        return BillType.walking;
    }
  }

  @override
  void write(BinaryWriter writer, BillType obj) {
    switch (obj) {
      case BillType.walking:
        writer.writeByte(0);
        break;
      case BillType.delivery:
        writer.writeByte(1);
        break;
      case BillType.inHouse:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BillTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OnlineStatusAdapter extends TypeAdapter<OnlineStatus> {
  @override
  final int typeId = 13;

  @override
  OnlineStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return OnlineStatus.offline;
      case 1:
        return OnlineStatus.processing;
      case 2:
        return OnlineStatus.online;
      default:
        return OnlineStatus.offline;
    }
  }

  @override
  void write(BinaryWriter writer, OnlineStatus obj) {
    switch (obj) {
      case OnlineStatus.offline:
        writer.writeByte(0);
        break;
      case OnlineStatus.processing:
        writer.writeByte(1);
        break;
      case OnlineStatus.online:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OnlineStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BillingStatusAdapter extends TypeAdapter<BillingStatus> {
  @override
  final int typeId = 14;

  @override
  BillingStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BillingStatus.onHold;
      case 1:
        return BillingStatus.refunded;
      case 2:
        return BillingStatus.processed;
      default:
        return BillingStatus.onHold;
    }
  }

  @override
  void write(BinaryWriter writer, BillingStatus obj) {
    switch (obj) {
      case BillingStatus.onHold:
        writer.writeByte(0);
        break;
      case BillingStatus.refunded:
        writer.writeByte(1);
        break;
      case BillingStatus.processed:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BillingStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
