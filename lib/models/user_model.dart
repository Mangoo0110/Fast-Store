import 'package:easypos/data/data_field_names/data_field_names.dart';

class UserModel {
  final String userId;
  final String userImageId;
  final String email;
  String fullName;
  String contactNo;

  UserModel({required this.userId, required this.userImageId, required this.email, required this.fullName, required this.contactNo});

  factory UserModel.fromMap({required Map<String, dynamic>map}) {
    return UserModel(
      userId: map[kuserId] ?? '', 
      userImageId: map[kuserImageId] ?? '', 
      email: map[kemail] ?? '', 
      fullName: map[kfullName] ?? '',
      contactNo: map[kcontactNo] ?? ''
    );
  }

  toMap(){
    return {
      kuserId : userId,
      kuserImageId : userImageId,
      kemail : email,
      kfullName : fullName,
      kcontactNo : contactNo
    };
  }
}