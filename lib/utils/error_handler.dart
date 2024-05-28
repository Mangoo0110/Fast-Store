// import 'dart:convert';

// import 'package:flutter/material.dart';

// void httpErrorHandle({
//   required http.Response response,
//   required VoidCallback onSuccess,
// }) {
//   switch(response.statusCode) {
//     case 200:
//       onSuccess();
//       break;
//     case 400:
//       Fluttertoast.showToast(msg: jsonDecode(response.body)['error']);
//       // showSnakeBar(context, jsonDecode(response.body)['msg']);
//       break;
//     case 500:
//       // print(jsonDecode(response.body)['msg']);
//       Fluttertoast.showToast(msg: jsonDecode(response.body)['message']);
//       // showSnakeBar(context, jsonDecode(response.body)['msg']);
//       break;
//     default:
//       Fluttertoast.showToast(msg: jsonDecode(response.body)['msg']);
//       // showSnakeBar(context, response.body);
//   }
// }