// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:easypos/data/data_field_names/data_field_names.dart';
// import 'package:easypos/models/billing_product.dart';

// class OrderModel {
//   final String orderId;
//   final String customerName;
//   final String customerContactNo;
//   final Map<String, BillingProduct>idMappedbilledProductList;
//   final double totalAmount;
//   final double totalAmountReceived;
//   final double dueAmount;
//   final bool onHouse;
//   final DateTime? billedAt;
//   final DateTime? deliveryDateTime;
//   final String deliveryAddress;

//   OrderModel(
//       {required this.orderId,
//       required this.customerName,
//       required this.customerContactNo,
//       required this.idMappedbilledProductList,
//       required this.totalAmount,
//       required this.totalAmountReceived,
//       required this.dueAmount,
//       required this.onHouse,
//       required this.billedAt,
//       required this.deliveryAddress,
//       required this.deliveryDateTime});

//   factory OrderModel.fromMap({required Map<String, dynamic> map}) {
//     Map<String, dynamic> idMappedbilledProductsRaw = map[kidMapbilledProducts] ?? Map<String, dynamic>.from(map[kidMapbilledProducts]);
//     Map<String, BillingProduct> idMappedbilledProducts = idMappedbilledProductsRaw.map((key, value) => MapEntry(key, BillingProduct.fromMap(map: value)));
//     return OrderModel(
//         orderId: map[kbillId] ?? '',
//         customerName: map[kcustomerName] ?? '',
//         customerContactNo: map[kcustomerContactNo] ?? '',
//         idMappedbilledProductList: idMappedbilledProducts,
//         totalAmount: map[ktotalAmount] ?? 0,//double.tryParse(map[ktotalAmount]) ?? 0.0,
//         totalAmountReceived: map[ktotalAmount] ?? 0,//double.tryParse(map[ktotalAmount]) ?? 0.0,
//         dueAmount: map[kdueAmount] ?? 0,//double.tryParse(map[kdueAmount]) ?? 0.0,
//         onHouse: map[konHouse] ?? false,//bool.tryParse(map[konHouse]) ?? false,
//         billedAt: map[kbilledAt]== null ? null : DateTime.parse(map[kbilledAt]),
//         deliveryAddress: map[kdeliveryAddress] ?? 'From Store',
//         deliveryDateTime: map[kdeliveryDateTime]== null ? null : DateTime.parse(map[kbilledAt]),
//       );
//   }

//   toMap(){
//     Map<String, Map<String, dynamic>> idMappedbilledProductsRaw = idMappedbilledProductList.map((key, value) => MapEntry(key, value.toMap()));
//     return {
//       kbillId: orderId,
//       kcustomerName: customerName,
//       kcustomerContactNo: customerContactNo,
//       kidMapbilledProducts: idMappedbilledProductsRaw,
//       ktotalAmount: totalAmount,
//       kdueAmount: dueAmount,
//       konHouse: onHouse.toString(),
//       kbilledAt: billedAt == null ? null : Timestamp.fromDate(billedAt!.toUtc()),
//       kdeliveryAddress: deliveryAddress,
//       kdeliveryDateTime: deliveryDateTime == null ? null : Timestamp.fromDate(deliveryDateTime!.toUtc())
//     };
//   }
// }
