import 'package:easypos/models/bill_model.dart';
import 'package:easypos/models/payment_model.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
class ConnectPrinterProvider extends ChangeNotifier{
  PrinterBluetoothManager _printerBluetoothManager = PrinterBluetoothManager();
  List<PrinterBluetooth> _printers = [];
  PrinterBluetooth? _selectedPrinter;

  PrinterBluetooth? get selectedPrinter => _selectedPrinter;

  List<PrinterBluetooth> get printers => _printers;

  void scan() {
    _printers = [];
    
    _printerBluetoothManager.startScan(const Duration(seconds: 4));
    _printerBluetoothManager.scanResults.listen((bluetoothDevices) {
      for (var index = 0; index < bluetoothDevices.length; index++) {
        if(_isPrinter(bluetoothDevices[index])) {
          _printers.add(bluetoothDevices[index]);
        }
      }
      notifyListeners();
    });
  }


  void selectPrinter({required PrinterBluetooth printer}) {
    _selectedPrinter = null;
    try {
      _printerBluetoothManager.selectPrinter(printer);
      _selectedPrinter = printer;
      notifyListeners();
    } catch (e) {
      Fluttertoast.showToast(msg: "Could not select printer!");
    }
    
  }

  Future<void> printBillInvoice({required BillModel bill, required String storeName, required storeAddress, required String storeContactDetails}) async{
    List<int>bytes = [];
    PaperSize paperSize = PaperSize.mm58;
    final profile = await CapabilityProfile.load();
    final Generator ticket = Generator(paperSize, profile);
    _storeHeader(ticket: ticket, storeName: storeName, storeAddress: storeAddress, storeContactDetails: storeContactDetails);
    bytes += ticket.hr(linesAfter: 4);
    _customerDetails(ticket: ticket, bill: bill);
    _billedProductList(ticket: ticket, bill: bill);
    bytes += ticket.hr(ch: '=', linesAfter: 1);
    _paymentDetails(ticket: ticket, bill: bill);

    bytes += ticket.feed(2);
    bytes += ticket.text('Thank you!',
        styles: const PosStyles(align: PosAlign.center, bold: true));

    final now = DateTime.now();
    final formatter = DateFormat('MM/dd/yyyy H:m');
    final String timestamp = formatter.format(now);
    bytes += ticket.text(timestamp,
        styles: const PosStyles(align: PosAlign.center), linesAfter: 2);

    await _printerBluetoothManager.printTicket(bytes);
  }

  List<int> _customerDetails({required Generator ticket, required BillModel bill}) {
    List<int> bytes = [];
    bytes += ticket.text('Customer name:  ${bill.customerName}', styles: const PosStyles(bold: true, align: PosAlign.left),);
    bytes += ticket.text('Customer name:  ${bill.customerContactNo}', styles: const PosStyles(bold: true, align: PosAlign.left),);
    if(bill.billType == BillType.delivery) {

      bytes += ticket.row([
        PosColumn(text: "Delivery address: ", styles: const PosStyles(bold: true, align: PosAlign.left, height: PosTextSize.size2),),
        PosColumn(text: bill.deliveryInfo == null ? '' : bill.deliveryInfo!.deliveryAddress.toString(), styles: const PosStyles(bold: false, align: PosAlign.left),)
      ]);

      final deliveryDateTime = DateTime.now();
      final formatter = DateFormat('MM/dd/yyyy H:m');
      final String timestamp = formatter.format(deliveryDateTime);

      bytes += ticket.row([
        PosColumn(text: "Delivery time: ", styles: const PosStyles(bold: true, align: PosAlign.left, height: PosTextSize.size2),),
        PosColumn(text: timestamp.toString(), styles: const PosStyles(bold: false, align: PosAlign.left),)
      ]);
    }
    return bytes;
  }

  List<int> _storeHeader({required Generator ticket, required String storeName, required storeAddress, required String storeContactDetails}) {
    List<int> bytes = [];
    bytes += ticket.text(storeName, styles: const PosStyles(bold: true, align: PosAlign.center, height: PosTextSize.size3,));
    
    if(storeAddress != '') {
      bytes += ticket.emptyLines(4);

      bytes += ticket.text(storeAddress, styles: const PosStyles(bold: false, align: PosAlign.center, height: PosTextSize.size2));
      bytes += ticket.text(storeContactDetails, styles: const PosStyles(bold: false, align: PosAlign.center, height: PosTextSize.size2));
    }
    

    return bytes;
  }

  List<int> _billedProductList({required Generator ticket, required BillModel bill}) {
    List<int> bytes = [];
    bytes += ticket.row([
      PosColumn(text: 'Qty', width: 1),
      PosColumn(text: 'Item', width: 7),
      PosColumn(
          text: 'Price', width: 2, styles: const PosStyles(align: PosAlign.right)),
      PosColumn(
          text: 'Total', width: 2, styles: const PosStyles(align: PosAlign.right)),
    ]);

    bill.idMappedBilledProductList.forEach((billingProductId, billingProduct) {
      bytes += ticket.row([
        PosColumn(text: billingProduct.quantity.toString(), width: 1),
        PosColumn(text: billingProduct.productName, width: 7),
        PosColumn(
            text: billingProduct.productPrice.toString(), width: 2, styles: const PosStyles(align: PosAlign.right)),
        PosColumn(
            text: billingProduct.totalPrice.toString(), width: 2, styles: const PosStyles(align: PosAlign.right)),
      ]);
    });
    return bytes;
  }

  List<int> _paymentDetails({required Generator ticket, required BillModel bill}) {
    List<int> bytes = [];
    String paymentMethod = 'Cash';
    // if(bill.paymentList == PaymentMethod.card) paymentMethod = 'Card';
    // if(bill.paymentList == PaymentMethod.mobileBanking) paymentMethod = 'Mobile Banking';
    // if(bill.paymentList == PaymentMethod.visa) paymentMethod = 'Visa';
    // if(bill.paymentList == PaymentMethod.mastercard) paymentMethod = 'MasterCard';
    // if(bill.paymentList == PaymentMethod.bkash) paymentMethod = 'Bkash';
    // if(bill.paymentList == PaymentMethod.nogod) paymentMethod = 'Nogod';

    if(bill.billType == BillType.delivery) {
      bytes += ticket.row([
        PosColumn(text: "Delivery charge: ", styles: const PosStyles(bold: true, align: PosAlign.left, height: PosTextSize.size2),),
        PosColumn(text: bill.payableAmount.toString(), styles: const PosStyles(bold: false, align: PosAlign.left),)
      ]);
    }

    bytes += ticket.row([
      PosColumn(text: "$paymentMethod: ", styles: const PosStyles(bold: true, align: PosAlign.left, height: PosTextSize.size2),),
      PosColumn(text: bill.payableAmount.toString(), styles: const PosStyles(bold: false, align: PosAlign.left),)
    ]);

    bytes += ticket.row([
      PosColumn(text: bill.dueAmount > 0 ? "Due: " : "Change: ", styles: const PosStyles(bold: true, align: PosAlign.left, height: PosTextSize.size2),),
      PosColumn(text: bill.dueAmount.abs().toString(), styles: const PosStyles(bold: false, align: PosAlign.left),)
    ]);

    return bytes;
  }

  bool _isPrinter(PrinterBluetooth device) {
    return device.name != null && device.name!.toLowerCase().contains('printer');
  }
}