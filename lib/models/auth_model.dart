import 'dart:convert';

import 'package:easypos/data/data_field_names/data_field_names.dart';




class AuthModel {
  final String email;
  final String password;
  final bool emailVerified;
  const AuthModel({required this.email, required this.emailVerified, required this.password});

  factory AuthModel.fromMap(Map<String, dynamic>map) {
    return AuthModel(
      email: map[kemail] ?? "", 
      emailVerified: false, 
      password: map[kPassword] ?? ""
      );
  }

  factory AuthModel.fromJson(String source) {
    Map<String, dynamic> parsedJson = jsonDecode(source);
    return AuthModel.fromMap(parsedJson);
  }

  toMap() {
    return {
      kemail : email,
      kPassword : password,
    };
  }
}