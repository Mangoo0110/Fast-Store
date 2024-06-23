import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easypos/core/failure.dart';
import 'package:easypos/data/connection_check/online_or_not.dart';
import 'package:easypos/data/data_field_names/hive_boxes.dart';
import 'package:easypos/data/datasources/firebase/firebase_store_billing_repo_impl.dart';
import 'package:easypos/data/datasources/local/hive_bill_repo_impl.dart';
import 'package:easypos/data/datasources/local/hive_processed_bill_repo_impl.dart';
import 'package:easypos/models/bill_model.dart';
import 'package:easypos/models/billing_product.dart';
import 'package:easypos/models/delivery_info_model.dart';
import 'package:easypos/models/payment_model.dart';
import 'package:easypos/models/product_model.dart';
import 'package:easypos/utils/dekhao.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BillingDataController extends ChangeNotifier {

  late OnlineOrNot _onlineOrNot;

  BillModel? _currentBill;

  Map<String, BillModel>_onHoldBillQueue = {};

  final StreamController<List<BillModel>> _processedBillStreamController = StreamController.broadcast();

  final StreamController<List<BillModel>> _onHoldBillStreamController = StreamController.broadcast();

  Map<String, BillModel> _processedBills = {};

  Map<String, BillModel> get onHoldBillQueue => _onHoldBillQueue;

  Map<String, BillModel> get processedBills => _processedBills;

  BillModel? get currentBill => _currentBill;

  InternetStatus get internetStatus => _onlineOrNot.internetStatus; 

  BillingDataController() {
    _onlineOrNot = OnlineOrNot();

    // Future.delayed(const Duration(seconds: 1), () async{
    //   onHoldBillbox = await HiveBoxes().onHoldBillBox();
    // });
    // Box<BillModel> onHoldBillbox = await HiveBoxes().onHoldBillBox();
    // HiveOnHoldBillRepoImpl(streamController: _onHoldBillStreamController, box: HiveBoxes().billBox())
  }


  changeCurrentBillType({required BillType billType}) {
    if(currentBill != null) {
      BillModel bill = currentBill!;
      bill.billType = billType;
      if(billType == BillType.delivery) {
        bill.deliveryInfo = DeliveryInfoModel(deliveryAddress: '', deliveryDateTime: DateTime.now(), deliveryPhase: DeliveryPhase.processing);
        bill.deliveryInfo!.deliveryPhase = DeliveryPhase.processing;
      } else {
        bill.deliveryInfo = null;
      }
      _currentBill = bill;
      notifyListeners();
    }

  }

  newBill({required String storeId}){
    final bill = BillModel(
      billId: FirebaseBillingRepoImpl().newBillId(storeId: storeId),
      localBillNo: '',
      billType: BillType.walking, 
      billerName: 'Owner', 
      billerId: '', 
      customerName: '', 
      customerContactNo: '', 
      idMappedBilledProductList: {}, 
      subTotal: 0,
      discountPercentage: 0,
      taxNameMapPercentage: {},
      payableAmount: 0, 
      totalReceivedAmount: 0, 
      dueAmount: 0, 
      billedAt: DateTime.now(), 
      deliveryCharge: 0, 
      deliveryInfo: null,
      paymentList: [], discountValue: 0, 
      onlineStatus: OnlineStatus.offline,
      billingStatus: BillingStatus.onHold);
    
    _currentBill = bill;
    notifyListeners();
    return bill;
  }

  removeCurrentBill() {
    notifyListeners();
    _currentBill = null;
  }

  setCurrentBill({required BillModel bill}) {
    _currentBill = bill;
    notifyListeners();
  }

  editCustomerDetailsOfBill({required String customerName, required String customerContactNo, required String deliveryAddress, required DateTime deliveryTime}) {
    if(currentBill != null) {
      BillModel bill = currentBill!;
      bill.customerName = customerName;
      bill.customerContactNo = customerContactNo;

      if(bill.billType == BillType.delivery) {
        
        bill.deliveryInfo ??= DeliveryInfoModel(deliveryAddress: '', deliveryDateTime: DateTime.now(), deliveryPhase: DeliveryPhase.processing);

        bill.deliveryInfo!.deliveryAddress = deliveryAddress;
        bill.deliveryInfo!.deliveryDateTime = deliveryTime;
      }
      _currentBill = bill;
      notifyListeners();
    }
  }

  // currentBillPaymentDetails({ required double receivedAmount, required PaymentMethod paymentMethod}) {
  //   if(currentBill != null) {
  //     BillModel bill = currentBill!;
  //     bill.totalReceivedAmount = receivedAmount;
  //     bill.dueAmount = max(0, bill.payableAmount - receivedAmount);
  //     _currentBill = bill;
  //     notifyListeners();
  //   }
  // }

  addBillingProduct({required ProductModel product, required double addingUnit, required BillingMethod billigMethod}) {
    if(currentBill != null) {

      BillModel existingBill = currentBill!;

      double quantity = addingUnit;

      double totalDiscountValue = quantity * product.productPrice * product.discountPercentage/100;

      BillingProduct? existingBillingProduct;

      if(existingBill.idMappedBilledProductList.containsKey(product.productId)) {

        existingBillingProduct = existingBill.idMappedBilledProductList[product.productId];
        quantity += existingBillingProduct!.quantity;
        totalDiscountValue = quantity * existingBillingProduct.productPrice * existingBillingProduct.discountPercentage/100;

      }
      
      existingBill.idMappedBilledProductList[product.productId] = 
      BillingProduct(
        productName: product.productName, 
        itemBarcode: product.itemBarcode,
        billingMethod: billigMethod,
        productImageId: product.productImageId,
        quantity: quantity, 
        totalDiscountValue: totalDiscountValue,
        totalPrice: (quantity * product.productPrice) - totalDiscountValue,
        discountPercentage: existingBillingProduct == null ? product.discountPercentage : existingBillingProduct.discountPercentage, 
        productId: product.productId,
        pieceProduct: product.pieceProduct, productPrice: product.productPrice, variantId: product.productId,
      );

      dekhao("existing bill total amount before ${existingBill.payableAmount}");
      _currentBill = doTheTotalOfBillAfterBillingProduct(bill: existingBill);
      notifyListeners();

    }else{
      Fluttertoast.showToast(msg: 'Bill id does not exist!');
    }
  }

  addScannedBillingProduct({required ProductModel product, required double addingUnit}) {
    if(currentBill != null) {

      BillModel existingBill = currentBill!;
      double quantity = addingUnit;
      BillingProduct? beforeEdit;
      if(existingBill.idMappedBilledProductList.containsKey(product.productId)) {
        beforeEdit = existingBill.idMappedBilledProductList[product.productId];
        quantity += existingBill.idMappedBilledProductList[product.productId]!.quantity;

      }
      double totalDiscountValue = beforeEdit == null ? 0 : quantity * beforeEdit.productPrice * beforeEdit.discountPercentage/100;
      existingBill.idMappedBilledProductList[product.productId] = 
      BillingProduct(
        productName: product.productName, 
        itemBarcode: product.itemBarcode,
        billingMethod: BillingMethod.scan,
        productImageId: product.productImageId,
        quantity: quantity, 
        totalDiscountValue: totalDiscountValue,
        totalPrice: (quantity * product.productPrice) - totalDiscountValue,
        discountPercentage: beforeEdit == null ? 0 : beforeEdit.discountPercentage, 
        productId: product.productId,
        pieceProduct: product.pieceProduct, productPrice: product.productPrice, variantId: product.productId,
      );

      dekhao("existing bill total amount before ${existingBill.payableAmount}");
      _currentBill = doTheTotalOfBillAfterBillingProduct(bill: existingBill);
      notifyListeners();

    }else{
      Fluttertoast.showToast(msg: 'Bill id does not exist!');
    }
  }

  editSoldUnitOfProduct({required double handTypedSoldUnit, required String productId, required BillingMethod billigMethod}){
    dekhao('handTypedSoldUnit $handTypedSoldUnit');
    if(currentBill != null) {
      BillModel bill = currentBill!;
      
      if(bill.idMappedBilledProductList.containsKey(productId)) {
        final beforeEditBP = bill.idMappedBilledProductList[productId]!;
        
        if(handTypedSoldUnit <= 0) {
          bill.idMappedBilledProductList.remove(productId);
          _currentBill = doTheTotalOfBillAfterBillingProduct(bill: bill);
          
        } else {
          double totalDiscountValue = handTypedSoldUnit * beforeEditBP.productPrice * beforeEditBP.discountPercentage/100;
          final afterEditBP = 
          BillingProduct(
            productId: productId,
            itemBarcode: beforeEditBP.itemBarcode,
            billingMethod: billigMethod,
            productImageId: beforeEditBP.productImageId,
            productName: beforeEditBP.productName, 
            productPrice: beforeEditBP.productPrice,
            quantity: handTypedSoldUnit, 
            discountPercentage: beforeEditBP.discountPercentage,
            totalDiscountValue: totalDiscountValue,
            totalPrice: (handTypedSoldUnit * beforeEditBP.productPrice) - totalDiscountValue, 
            pieceProduct: beforeEditBP.pieceProduct, variantId: productId,
          );
          
          bill.idMappedBilledProductList[productId] = afterEditBP;
          _currentBill = doTheTotalOfBillAfterBillingProduct(bill: bill);

        }
        notifyListeners();

      }
    }
  }

  productDiscount({required double discountPercentage, required String productId}){
    dekhao('discountPercentage $discountPercentage');
    if(currentBill != null) {
      final bill = currentBill!;
      
      if(bill.idMappedBilledProductList.containsKey(productId)) {

        final billingProduct = bill.idMappedBilledProductList[productId]!;
        billingProduct.discountPercentage = discountPercentage;
        billingProduct.totalPrice = max(0, (billingProduct.quantity * billingProduct.productPrice) * (1 - billingProduct.discountPercentage/100));

        bill.idMappedBilledProductList[productId] = billingProduct;
        _currentBill= doTheTotalOfBillAfterBillingProduct(bill: bill);
        notifyListeners();

      }
    }
  }


  

  BillModel doTheTotalOfBillAfterBillingProduct({required BillModel bill}){
    bill.payableAmount = 0;
    bill.subTotal = 0;
    
    bill.idMappedBilledProductList.forEach((key, value){
      bill.subTotal = bill.subTotal + value.totalPrice;
    });
    double taxTotal = 0;
    bill.taxNameMapPercentage.forEach((key, value){
      taxTotal = taxTotal +  bill.subTotal * (value)/100;
    });
    bill.payableAmount = bill.subTotal + taxTotal;

    bill.dueAmount = max(0, (bill.payableAmount - bill.totalReceivedAmount) );

    return bill;
  }

  deleteProductFromBill({required String productId}) {
    if(currentBill != null) {
      BillModel bill = currentBill!;
      bill.idMappedBilledProductList.remove(productId);
      _currentBill = doTheTotalOfBillAfterBillingProduct(bill: bill);
      notifyListeners();

    }

  }
  
  editReceivedMoneyOfBill({required double receivedMoney}) {
    if(currentBill != null) {
      BillModel bill = currentBill!;
      bill.totalReceivedAmount = receivedMoney;
      bill.dueAmount = bill.payableAmount - bill.totalReceivedAmount ;
      if(bill.dueAmount < 0) bill.dueAmount = 0;
      _currentBill = bill;
      notifyListeners();

    }
  }

  Future<bool> confirmCheckout({required PaymentModel paymentModel, required String storeId}) async{
    
    if(currentBill != null) {
      dekhao("confirmCheckout");
      currentBill!.totalReceivedAmount += min(currentBill!.payableAmount, paymentModel.paidAmount);
      currentBill!.dueAmount = max(0, currentBill!.dueAmount - paymentModel.paidAmount) ;
      currentBill!.paymentList.add(paymentModel);

      if(currentBill!.dueAmount < 0) currentBill!.dueAmount = 0;
      await uploadProcessedBill(bill: currentBill!, storeId: storeId).then((value) {
        if(value) {
          removeCurrentBill();
        } else {
          Fluttertoast.showToast(msg: 'Checkout failed!');
        }
      });
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> holdBilledCheck({required String storeId}) async{
    
    if(currentBill != null) {

      await uploadOnHoldBill(bill: currentBill!, storeId: storeId).then((value) {
        if(value) {
          removeCurrentBill();
        } else {
          Fluttertoast.showToast(msg: 'Check hold failed!');
        }
      });
      notifyListeners();
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    _onHoldBillStreamController.close();
    _processedBillStreamController.close();
    super.dispose();
  }

  Future<void> fetchOnHoldBillList({required String storeId}) async{
    _onHoldBillQueue = {};
    final hiveLocal = HiveOnHoldBillRepoImpl(streamController: _onHoldBillStreamController, box: await HiveBoxes().onHoldBillBox());
    FirebaseBillingRepoImpl()
      .fetchOnHoldBillList(storeId: storeId)
        .fold(
          (dataFailure) {
            //Fluttertoast.showToast(msg: '');
            //_onHoldBillStreamController.stream
          }, 
          (dataStream) {
            dataStream.listen((billModelList) async{

              for(final bill in billModelList) {
                if(bill.billingStatus == BillingStatus.onHold){
                  await hiveLocal.addUpdateBill(bill: bill);
                  _onHoldBillQueue[bill.billId] = bill;
                }
                
              }

            });
          }
        );

    hiveLocal.onHoldBillStream.listen((billModelList) async{
      for(final bill in billModelList) {
        if(bill.billingStatus == BillingStatus.onHold){
          _onHoldBillQueue[bill.billId] = bill;
        }
        
      }
      notifyListeners();
    });
    
  }

  Future<void> fetchProcessedBillList({required String storeId, required DateTime date}) async{
    _processedBills = {};
    //notifyListeners();
    final processedBillHive = HiveProcessedBillRepoImpl(streamController: _processedBillStreamController, box: await HiveBoxes().processedBillBox());
    FirebaseBillingRepoImpl()
      .fetchBillListInTimeRange(storeId: storeId, fromTime: Timestamp.fromDate(date), toTime: Timestamp.fromDate(DateTime(date.year, date.month, date.day, 23, 59, 59)))
        .fold(
          (dataFailure) {
            processedBillHive.processedBillStream.listen((billModelList) async{
              for(final bill in billModelList) {
                _processedBills[bill.billId] = bill;
              }
              notifyListeners();
            });
          }, 
          (dataStream) {
            dataStream.listen((billModelList) async{

              for(final bill in billModelList) {
                await processedBillHive.addUpdateBill(bill: bill);
                _processedBills[bill.billId] = bill;
                notifyListeners();
              }
              notifyListeners();
            });
          }
        );
  }

  Future<bool> uploadOnHoldBill({required BillModel bill, required String storeId}) async{
    if(bill.billingStatus != BillingStatus.onHold) {
      return false;
    }
    return await FirebaseBillingRepoImpl().uploadBill(bill: bill, storeId: storeId).then((dataResult) {
      return dataResult.fold(
        (dataFailure) {
          Fluttertoast.showToast(msg: 'Failed! Bill could not be uploaded.');
          if(dataFailure.failure == Failure.socketFailure) {
            Fluttertoast.showToast(msg: "You are offline. Check your internet connection");
          }
          if(dataFailure.failure == Failure.severFailure) {
            Fluttertoast.showToast(msg: "Failure: Server failed.");
          } else {
            Fluttertoast.showToast(msg: dataFailure.message);
          }
          return false;
        }, 
        (dataStream) {
          Fluttertoast.showToast(msg: 'Bill processed successfully.');
          return true;
        }
      );
    });
  }

  Future<bool> uploadProcessedBill({required BillModel bill, required String storeId}) async{
    bill.billingStatus = BillingStatus.processed;
    if(_onHoldBillQueue.containsKey(bill.billId)) {
      _onHoldBillQueue.remove(bill.billId);
      notifyListeners();
    }
    return await FirebaseBillingRepoImpl().uploadBill(bill: bill, storeId: storeId).then((dataResult) {
      return dataResult.fold(
        (dataFailure) {
          Fluttertoast.showToast(msg: 'Failed! Bill could not be uploaded.');
          if(dataFailure.failure == Failure.socketFailure) {
            Fluttertoast.showToast(msg: "You are offline. Check your internet connection");
          }
          if(dataFailure.failure == Failure.severFailure) {
            Fluttertoast.showToast(msg: "Failure: Server failed.");
          } else {
            Fluttertoast.showToast(msg: dataFailure.message);
          }
          return false;
        }, 
        (dataStream) {
          Fluttertoast.showToast(msg: 'Bill processed successfully.');
          return true;
        }
      );
    });
  }
  
}