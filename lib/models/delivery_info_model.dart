import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easypos/data/data_field_names/data_field_names.dart';
import 'package:hive/hive.dart';
part 'delivery_info_model.g.dart';

@HiveType(typeId: 5)
enum DeliveryPhase {
  @HiveField(0)
  processing,

  @HiveField(1)
  ready,

  @HiveField(2)
  delivered,
}

@HiveType(typeId: 6)
class DeliveryInfoModel {
  @HiveField(0)
  DateTime deliveryDateTime;

  @HiveField(1)
  String deliveryAddress;

  @HiveField(2)
  DeliveryPhase deliveryPhase = DeliveryPhase.delivered;

  DeliveryInfoModel(
      {required this.deliveryAddress,
      required this.deliveryDateTime,
      required this.deliveryPhase});

  factory DeliveryInfoModel.fromMap({required Map<String, dynamic> map}) {
    return DeliveryInfoModel(
      deliveryAddress: map[kdeliveryAddress] ?? '(From Store)',
      deliveryDateTime: map[kdeliveryDateTime]== null ? DateTime(DateTime.now().year) : DateTime.parse(map[kbilledAt]), 
      deliveryPhase: map[kdeliveryPhase].toString() == DeliveryPhase.processing.name ? DeliveryPhase.delivered 
        : map[kdeliveryPhase].toString() == DeliveryPhase.ready.name ? DeliveryPhase.ready
          : DeliveryPhase.delivered
    );
  }

  Map<String, dynamic> toMap(){
    return {
      kdeliveryAddress: deliveryAddress,
      kdeliveryDateTime: Timestamp.fromDate(deliveryDateTime.toUtc()),
      kdeliveryPhase: deliveryPhase.name
    };
  }
}
