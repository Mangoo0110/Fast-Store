// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_info_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeliveryInfoModelAdapter extends TypeAdapter<DeliveryInfoModel> {
  @override
  final int typeId = 6;

  @override
  DeliveryInfoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeliveryInfoModel(
      deliveryAddress: fields[1] as String,
      deliveryDateTime: fields[0] as DateTime,
      deliveryPhase: fields[2] as DeliveryPhase,
    );
  }

  @override
  void write(BinaryWriter writer, DeliveryInfoModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.deliveryDateTime)
      ..writeByte(1)
      ..write(obj.deliveryAddress)
      ..writeByte(2)
      ..write(obj.deliveryPhase);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeliveryInfoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DeliveryPhaseAdapter extends TypeAdapter<DeliveryPhase> {
  @override
  final int typeId = 5;

  @override
  DeliveryPhase read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DeliveryPhase.processing;
      case 1:
        return DeliveryPhase.ready;
      case 2:
        return DeliveryPhase.delivered;
      default:
        return DeliveryPhase.processing;
    }
  }

  @override
  void write(BinaryWriter writer, DeliveryPhase obj) {
    switch (obj) {
      case DeliveryPhase.processing:
        writer.writeByte(0);
        break;
      case DeliveryPhase.ready:
        writer.writeByte(1);
        break;
      case DeliveryPhase.delivered:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeliveryPhaseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
