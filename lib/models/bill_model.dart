import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easypos/data/data_field_names/data_field_names.dart';
import 'package:easypos/models/billing_product.dart';

enum BillType {storeOrder, onlineOrder, inStore}

class BillModel {
  final String billId;
  final String localBillNo;
  BillType billType;
  String billerName;
  String billerId;
  String customerName;
  String customerContactNo;
  Map<String, BillingProduct> idMappedBilledProductList;
  double subTotal;
  double discount;
  Map<String, double> taxNameMapPercentage;
  double payableAmount;
  double totalAmountReceived;
  double dueAmount;
  bool onHouse;
  DateTime? billedAt;
  DateTime? deliveryDateTime;
  String deliveryAddress;

  BillModel({
      required this.billId,
      required this.localBillNo,
      required this.billType,
      required this.billerName,
      required this.billerId,
      required this.customerName,
      required this.customerContactNo,
      required this.idMappedBilledProductList,
      required this.subTotal,
      required this.taxNameMapPercentage,
      required this.discount,
      required this.payableAmount,
      required this.totalAmountReceived,
      required this.dueAmount,
      required this.onHouse,
      required this.billedAt,
      required this.deliveryAddress,
      required this.deliveryDateTime});

  factory BillModel.fromMap({required Map<String, dynamic> map}) {
    Map<String, dynamic> idMappedbilledProductsRaw = map[kidMapbilledProducts] ?? Map<String, dynamic>.from(map[kidMapbilledProducts]);
    Map<String, BillingProduct> idMappedbilledProducts = idMappedbilledProductsRaw.map((key, value) => MapEntry(key, BillingProduct.fromMap(map: value)));
    return BillModel(
        billId: map[kbillId] ?? 'no billId',
        localBillNo: map[klocalBillNo] ?? '',
        billType: map[kbillType].toString() == BillType.inStore.name ?
         BillType.inStore
          : map[kbillType].toString() == BillType.storeOrder.name ? 
            BillType.storeOrder
            : BillType.onlineOrder,
        billerName: map[kbillerName] ?? '',
        billerId: map[kbillerId] ?? '',
        customerName: map[kcustomerName] ?? 'no name',
        customerContactNo: map[kcustomerContactNo] ?? 'no contact no',
        idMappedBilledProductList: idMappedbilledProducts,
        subTotal: map[ksubTotal],
        taxNameMapPercentage: map[ktaxNameMapPercentage],
        discount: map[kdiscount],
        payableAmount: map[kpayableAmount],//double.tryParse(map[ktotalAmount]) ?? 0.0,
        totalAmountReceived: map[ktotalAmountReceived],//double.tryParse(map[ktotalAmount]) ?? 0.0,
        dueAmount: map[kdueAmount],//double.tryParse(map[kdueAmount]) ?? 0.0,
        onHouse: map[konHouse],//bool.tryParse(map[konHouse]) ?? false,
        billedAt: map[kbilledAt]== null ? null : DateTime.parse(map[kbilledAt]),
        deliveryAddress: map[kdeliveryAddress] ?? 'From Store',
        deliveryDateTime: map[kdeliveryDateTime]== null ? null : DateTime.parse(map[kbilledAt]),
      );
  }

  toMap(){
    Map<String, Map<String, dynamic>> idMappedbilledProductsRaw = idMappedBilledProductList.map((key, value) => MapEntry(key, value.toMap()));
    return {
      kbillId: billId,
      klocalBillNo: localBillNo,
      kbillType: billType.name,
      kbillerId: billerId,
      kbillerName: billerName,
      kcustomerName: customerName,
      kcustomerContactNo: customerContactNo,
      kidMapbilledProducts: idMappedbilledProductsRaw,
      ksubTotal: subTotal,
      ktaxNameMapPercentage: taxNameMapPercentage,
      kdiscount: discount,
      kpayableAmount: payableAmount,
      kdueAmount: dueAmount,
      konHouse: onHouse.toString(),
      kbilledAt: billedAt == null ? null : Timestamp.fromDate(billedAt!.toUtc()),
      kdeliveryAddress: deliveryAddress,
      kdeliveryDateTime: deliveryDateTime == null ? null : Timestamp.fromDate(deliveryDateTime!.toUtc())
    };
  }
}
