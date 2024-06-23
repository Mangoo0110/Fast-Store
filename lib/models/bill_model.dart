import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easypos/data/data_field_names/data_field_names.dart';
import 'package:easypos/models/billing_product.dart';
import 'package:easypos/models/delivery_info_model.dart';
import 'package:easypos/models/payment_model.dart';
import 'package:hive/hive.dart';

part 'bill_model.g.dart';

@HiveType(typeId: 10)
class BillModel {
  @HiveField(0)
  final String billId;

  @HiveField(1)
  final String localBillNo;

  @HiveField(2)
  BillType billType;

  @HiveField(3)
  String billerName;

  @HiveField(4)
  String billerId;

  @HiveField(5)
  String customerName;

  @HiveField(6)
  String customerContactNo;

  @HiveField(7)
  Map<String, BillingProduct> idMappedBilledProductList;

  @HiveField(8)
  double subTotal;

  @HiveField(9)
  double discountPercentage;

  @HiveField(10)
  double discountValue;

  @HiveField(11)
  Map<String, double> taxNameMapPercentage;

  @HiveField(12)
  double payableAmount;

  @HiveField(13)
  List<PaymentModel> paymentList;

  @HiveField(14)
  double totalReceivedAmount;

  @HiveField(15)
  double dueAmount;

  @HiveField(16)
  DateTime? billedAt;

  @HiveField(17)
  DeliveryInfoModel? deliveryInfo;

  @HiveField(18)
  double deliveryCharge;

  @HiveField(19)
  OnlineStatus onlineStatus;

  @HiveField(20)
  BillingStatus billingStatus;
  

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
      required this.discountPercentage,
      required this.discountValue,
      required this.payableAmount,
      required this.totalReceivedAmount,
      required this.paymentList,
      required this.dueAmount,
      required this.billedAt,
      required this.deliveryCharge,
      required this.deliveryInfo,
      required this.onlineStatus,
      required this.billingStatus});

  factory BillModel.fromMap({required Map<String, dynamic> map}) {
    Map<String, dynamic> idMappedbilledProductsRaw = map[kidMapbilledProducts] == null ? {} : Map<String, dynamic>.from(map[kidMapbilledProducts]);
    Map<String, BillingProduct> idMappedbilledProducts = idMappedbilledProductsRaw.map((key, value) => MapEntry(key, BillingProduct.fromMap(map: value)));
    
    List<Map<String, dynamic>> paymentListRaw = map[kpaymentList] == null ? [] : List<Map<String, dynamic>>.from(map[kpaymentList]);
    List<PaymentModel> paymentList = [];
    for(Map<String, dynamic> payment in paymentListRaw) {
      paymentList.add(PaymentModel.fromMap(map: payment));
    }

    Map<String, double> taxNameMapPercentage = {};
    Map<String, dynamic> taxNameMapPercentageRaw = map[ktaxNameMapPercentage];
    taxNameMapPercentageRaw.forEach((key, value) {
      if (value is double) {
        taxNameMapPercentage[key] = value;
      }
    });

    return BillModel(
        billId: map[kbillId] ?? '(no billId)',
        localBillNo: map[klocalBillNo] ?? '',
        billType: map[kbillType].toString() == BillType.inHouse.name ?
          BillType.inHouse
          : map[kbillType].toString() == BillType.walking.name ? 
            BillType.walking
            : BillType.delivery,
        billerName: map[kbillerName] ?? '',
        billerId: map[kbillerId] ?? '',
        customerName: map[kcustomerName] ?? '(no name)',
        customerContactNo: map[kcustomerContactNo] ?? '(no contact no)',
        idMappedBilledProductList: idMappedbilledProducts,
        subTotal: map[ksubTotal],
        taxNameMapPercentage: taxNameMapPercentage,
        discountPercentage: map[kdiscountPercentage],
        discountValue: map[kdiscountValue] ?? 0.0,
        payableAmount: map[kpayableAmount] ?? 0,//double.tryParse(map[ktotalAmount]) ?? 0.0,
        totalReceivedAmount: map[ktotalReceivedAmount] ?? 0,//double.tryParse(map[ktotalAmount]) ?? 0.0,
        paymentList: paymentList ,
        dueAmount: map[kdueAmount],//double.tryParse(map[kdueAmount]) ?? 0.0,
        billedAt: map[kbilledAt] == null ? null :( map[kbilledAt] as Timestamp).toDate(),
        deliveryCharge: map[kdeliveryCharge] ?? 0, 
        deliveryInfo: map[kdeliveryInfo] == null ? null : DeliveryInfoModel.fromMap(map: map[kdeliveryInfo]), 
        onlineStatus: map[konlineStatus].toString() == OnlineStatus.offline.name ?
          OnlineStatus.offline
          : map[konlineStatus].toString() == OnlineStatus.processing.name ?
            OnlineStatus.processing
            : OnlineStatus.online,
        billingStatus: map[kbillingStatus].toString() == BillingStatus.onHold.name ?
          BillingStatus.onHold
          : map[kbillingStatus].toString() == BillingStatus.processed.name ?
            BillingStatus.processed
            : BillingStatus.refunded,
      );
  }

  toMap(){
    Map<String, Map<String, dynamic>> idMappedbilledProductsRaw = idMappedBilledProductList.map((key, value) => MapEntry(key, value.toMap()));
    
    List<Map<String, dynamic>> paymentListRaw = [];
    for(final payment in paymentList) {
      paymentListRaw.add(payment.toMap());
    }
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
      kdiscountPercentage: discountPercentage,
      kdiscountValue: discountValue,
      kpayableAmount: payableAmount,
      ktotalReceivedAmount: totalReceivedAmount,
      kpaymentList: paymentListRaw,
      kdueAmount: dueAmount,
      kbilledAt: billedAt == null ? null : Timestamp.fromDate(billedAt!.toUtc()),
      kdeliveryCharge: deliveryCharge,
      konlineStatus: onlineStatus.name,
      kbillingStatus: billingStatus.name
    };
  }
}

@HiveType(typeId: 11)
enum BillType {

  @HiveField(0)
  walking, 

  @HiveField(1)
  delivery, 
  
  @HiveField(2)
  inHouse
}

@HiveType(typeId: 13)
enum OnlineStatus {

  @HiveField(0)
  offline, 

  @HiveField(1)
  processing, 
  
  @HiveField(2)
  online
}

@HiveType(typeId: 14)
enum BillingStatus {

  @HiveField(0)
  onHold, 

  @HiveField(1)
  refunded, 
  
  @HiveField(2)
  processed
}


