import 'package:easypos/data/data_field_names/data_field_names.dart';

class ReceivedMoneyMapFrequencyModel {
  final Map<double, int> receivedMoneyMapFrequency;

  ReceivedMoneyMapFrequencyModel({required this.receivedMoneyMapFrequency});

  factory ReceivedMoneyMapFrequencyModel.fromMap(Map<String, dynamic> map) {
    return ReceivedMoneyMapFrequencyModel(
      receivedMoneyMapFrequency: map[kreceivedMoneyMapFrequency] == null ? {} : Map<double, int>.from(map[kreceivedMoneyMapFrequency])
    );
  }

  toMap() {
    return {
      kreceivedMoneyMapFrequency: receivedMoneyMapFrequency
    };
  }
}