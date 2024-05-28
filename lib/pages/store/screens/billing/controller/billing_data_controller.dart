import 'dart:math';
import 'dart:typed_data';

import 'package:easypos/data/datasources/firebase/firebase_store_billing_repo_impl.dart';
import 'package:easypos/models/bill_model.dart';
import 'package:easypos/models/billing_product.dart';
import 'package:easypos/models/product_model.dart';
import 'package:easypos/utils/dekhao.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BillingDataController extends ChangeNotifier {

  Map<String, BillModel>_inStoreBillQueue = {};

  BillType _currentBillingType = BillType.inStore;

  double _totalAmountToBePaid = 0;
  double _amountPaidByCustomer = 0;
  double _changeAfterPay = 0;

  double get totalAmountToBePaid => _totalAmountToBePaid;

  double get amountPaidByCustomer => _amountPaidByCustomer;

  double get changeAfterPay => _changeAfterPay;

  BillType get currentBillingType => _currentBillingType;

  Map<String, BillModel> get inStoreBillQueue => _inStoreBillQueue;

  changeCurrentBillType({required BillType billType}) {
    _currentBillingType = billType;
    notifyListeners();

  }

  newBill({required String storeId}){
    final bill = BillModel(
      billId: FirebaseStoreBillingRepoImpl().newBillId(storeId: storeId),
      billType: BillType.inStore, 
      billerName: 'Owner', 
      billerId: '', 
      customerName: '', 
      customerContactNo: '', 
      idMappedBilledProductList: {}, 
      subTotal: 0,
      discount: 0,
      taxNameMapPercentage: {},
      payableAmount: 0, 
      totalAmountReceived: 0, 
      dueAmount: 0, 
      onHouse: false, 
      billedAt: DateTime.now(), 
      deliveryAddress: '', 
      deliveryDateTime: null,);
    
    _inStoreBillQueue[bill.billId] = bill;
    return bill;

  }


  addBillingProduct({required String billId, required ProductModel product, required double addingUnit, required double discountPercentage}) {
    if(_inStoreBillQueue.containsKey(billId)) {

      BillModel existingBill = _inStoreBillQueue[billId]!;
      double quantity = addingUnit;
      if(existingBill.idMappedBilledProductList.containsKey(product.productId)) {

        quantity += existingBill.idMappedBilledProductList[product.productId]!.quantity;

      }
      existingBill.idMappedBilledProductList[product.productId] = 
      BillingProduct(
        productName: product.productName, 
        itemBarcode: '',
        productImageId: product.productImageId,
        quantity: quantity, 
        totalPrice: max(0, (quantity * product.productPrice) * (1 - discountPercentage/100)),
        discountPercentage: discountPercentage, 
        productId: product.productId,
        pieceProduct: product.pieceProduct, productPrice: product.productPrice,
      );

      dekhao("existing bill total amount before ${existingBill.payableAmount}");
      _inStoreBillQueue[billId] = doTheTotalOfBillAfterBillingProduct(bill: existingBill);
      notifyListeners();

    }else{
      Fluttertoast.showToast(msg: 'Bill id does not exist!');
    }
  }

  editSoldUnitOfProduct({required String billId, required double handTypedSoldUnit, required String productId}){
    dekhao('handTypedSoldUnit $handTypedSoldUnit');
    if(_inStoreBillQueue.containsKey(billId)) {
      final bill = _inStoreBillQueue[billId]!;
      
      if(_inStoreBillQueue[billId]!.idMappedBilledProductList.containsKey(productId)) {
        final beforeEditBP = bill.idMappedBilledProductList[productId]!;
        
        if(handTypedSoldUnit <= 0) {
          bill.idMappedBilledProductList.remove(productId);
          _inStoreBillQueue[billId] = doTheTotalOfBillAfterBillingProduct(bill: bill);
          
        } else {
          final afterEditBP = 
          BillingProduct(
            productId: productId,
            itemBarcode: '',
            productImageId: beforeEditBP.productImageId,
            productName: beforeEditBP.productName, 
            productPrice: beforeEditBP.productPrice,
            quantity: handTypedSoldUnit, 
            discountPercentage: beforeEditBP.discountPercentage,
            totalPrice: (handTypedSoldUnit * beforeEditBP.productPrice) * (1 - beforeEditBP.discountPercentage/100), 
            pieceProduct: beforeEditBP.pieceProduct,
          );
          
          bill.idMappedBilledProductList[productId] = afterEditBP;
          _inStoreBillQueue[billId] = doTheTotalOfBillAfterBillingProduct(bill: bill);

        }
        notifyListeners();

      }
    }
  }

  productDiscount({required String billId, required double discountPercentage, required String productId}){
    dekhao('discountPercentage $discountPercentage');
    if(_inStoreBillQueue.containsKey(billId)) {
      final bill = _inStoreBillQueue[billId]!;
      
      if(_inStoreBillQueue[billId]!.idMappedBilledProductList.containsKey(productId)) {

        final billingProduct = bill.idMappedBilledProductList[productId]!;
        billingProduct.discountPercentage = discountPercentage;
        billingProduct.totalPrice = max(0, (billingProduct.quantity * billingProduct.productPrice) * (1 - billingProduct.discountPercentage/100));

        bill.idMappedBilledProductList[productId] = billingProduct;
        _inStoreBillQueue[billId] = doTheTotalOfBillAfterBillingProduct(bill: bill);
        notifyListeners();

      }
    }
  }

  // BillModel zeroBillingProductPriceAndQuantity({required BillModel bill, required String productId}) {
  //   if(bill.idMappedBilledProductList.containsKey(productId)) {
  //     BillingProduct billingProduct = bill.idMappedBilledProductList[productId]!;
  //     billingProduct.quantity = 0;
  //     billingProduct.totalPrice = 0;
  //     bill.idMappedBilledProductList[productId] = billingProduct;
  //   }
  //   return bill;
  // }
  
  // BillModel subtractBillingProductAndItsValue({required BillModel bill, required String productId}) {
  //   if(bill.idMappedBilledProductList.containsKey(productId)) {
  //     bill.subTotal -= bill.idMappedBilledProductList[productId]!.totalPrice;
  //     bill.payableAmount -= bill.idMappedBilledProductList[productId]!.totalPrice;
  //   }
  //   return bill;
  // }

  // BillModel addBillingProductPriceAndQuantity({required BillModel bill, required String productId, required double quantity}) {
  //   if(bill.idMappedBilledProductList.containsKey(productId)) {
  //     BillingProduct billingProduct = bill.idMappedBilledProductList[productId]!;
  //     billingProduct.quantity = quantity;
  //     billingProduct.totalPrice =  (billingProduct.quantity * billingProduct.productPrice) * (1 - billingProduct.discountPercentage/100);;
  //     bill.idMappedBilledProductList[productId] = billingProduct;
  //   }
  //   return bill;
  // }

  

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

    bill.totalAmountReceived = bill.payableAmount;
    
    bill.dueAmount = bill.totalAmountReceived - bill.payableAmount;

    return bill;
  }

  deleteProductFromBill({required String billId, required String productId}) {
    if(_inStoreBillQueue.containsKey(billId)) {
      final bill = _inStoreBillQueue[billId]!;
      bill.idMappedBilledProductList.remove(productId);
      _inStoreBillQueue[billId] = doTheTotalOfBillAfterBillingProduct(bill: bill);
      notifyListeners();

    }

  }


  setAmountPaidByCustomer({required double amountPaidByCustomer}){
    _amountPaidByCustomer = amountPaidByCustomer;
    _changeAfterPay = _totalAmountToBePaid - _amountPaidByCustomer;
    notifyListeners();
  }
  
  editReceivedMoneyOfBill({required double receivedMoney, required String billId}) {
    if(_inStoreBillQueue.containsKey(billId)) {
      BillModel bill = _inStoreBillQueue[billId]!;
      bill.totalAmountReceived = receivedMoney;
      bill.dueAmount = bill.payableAmount - bill.totalAmountReceived ;
      if(bill.dueAmount < 0) bill.dueAmount = 0;
      _inStoreBillQueue[billId] = bill;
      dekhao(bill.toMap());
      notifyListeners();

    }
  }

  Future<void> recordBillOnline() async{
    //await Firebase
    _totalAmountToBePaid = 0;
    _amountPaidByCustomer = 0;
    _changeAfterPay = 0;
    notifyListeners();

  }


}