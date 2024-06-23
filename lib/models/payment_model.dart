import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easypos/data/data_field_names/data_field_names.dart';
import 'package:easypos/models/bill_model.dart';
import 'package:hive/hive.dart';
part 'payment_model.g.dart'; // Generated file name


@HiveType(typeId: 7)

enum PaymentMethod {
  @HiveField(0)
  cash,

  @HiveField(1)
  visa,

  @HiveField(2)
  mastercard,

  @HiveField(3)
  bkash,

  @HiveField(4)
  nogod,

  @HiveField(5)
  card,

  @HiveField(6)
  mobileBanking,

  @HiveField(7)
  other,

  @HiveField(8)
  onHouse,
}

@HiveType(typeId: 8) // Annotate with HiveType and specify a typeId
class PaymentModel {
  @HiveField(0) // Annotate fields that need to be serialized with HiveField
  String transactionId;

  @HiveField(1)
  PaymentMethod paymentMethod;

  @HiveField(2)
  double paidAmount;

  @HiveField(3)
  DateTime? transactionAt;

  PaymentModel({required this.transactionId, required this.paymentMethod, required this.paidAmount, required this.transactionAt});

  factory PaymentModel.fromMap({required Map<String, dynamic> map}) {
    return PaymentModel(
      transactionId: map[ktransactionId] ?? '', 
      paymentMethod: map[kpaymentMethod].toString() == PaymentMethod.cash.name ?
          PaymentMethod.cash
          : map[kpaymentMethod].toString() == PaymentMethod.card.name ?
            PaymentMethod.card
            : map[kpaymentMethod].toString() == PaymentMethod.mobileBanking.name ?
              PaymentMethod.mobileBanking
              : map[kpaymentMethod].toString() == PaymentMethod.visa.name ?
                PaymentMethod.visa
                : map[kpaymentMethod].toString() == PaymentMethod.mastercard.name ?
                  PaymentMethod.mastercard
                  : map[kpaymentMethod].toString() == PaymentMethod.bkash.name ?
                    PaymentMethod.bkash
                    : map[kpaymentMethod].toString() == PaymentMethod.nogod.name ?
                      PaymentMethod.nogod
                      : map[kpaymentMethod].toString() == PaymentMethod.onHouse.name ?
                        PaymentMethod.onHouse 
                        : PaymentMethod.other, 
      paidAmount: map[kpaidAmount] ?? 0,
      transactionAt: map[ktransactionAt] == null ? null : ( map[ktransactionAt] as Timestamp).toDate(),
    );
  }

  toMap() {
    return {
      ktransactionId: transactionId,
      kpaymentMethod: paymentMethod.name,
      kpaidAmount: paidAmount,
      ktransactionAt: transactionAt == null ? Timestamp.fromDate(DateTime.now()) : Timestamp.fromDate(transactionAt!),
    };
  }

  factory PaymentModel.empty() {
    return PaymentModel(transactionId: '', paymentMethod: PaymentMethod.cash, paidAmount: 0, transactionAt: DateTime.now());
  }
}