import 'package:easypos/data/data_field_names/data_field_names.dart';

class TaxMapModel{

  Map<String, double> taxNameMapPercentage;

  TaxMapModel({required this.taxNameMapPercentage,});
  factory TaxMapModel.fromMap({required Map<String, dynamic> map}) {
    return TaxMapModel(taxNameMapPercentage: map[ktaxNameMapPercentage]);
  }

  toMap(){
    return {
      ktaxNameMapPercentage: taxNameMapPercentage
    };
  }
  
}

