import 'package:easypos/models/bill_model.dart';
import 'package:easypos/models/billing_product.dart';
import 'package:flutter/material.dart';

class AppColors {

  Color appButtonFillColor(){
    return const Color.fromARGB(255, 121, 51, 241);
  }

  Color appSelectionColor(){
    return Colors.blue.withAlpha(50);
  }

  Color appActionColor ({
    required BuildContext context
  }) {
    return  Colors.orange.shade400;
  }
  Color appAccentColor ({
    required BuildContext context
  }) {
    return Colors.orange.shade200;
  }

  Color appInfoContainerColor(){
    return Colors.grey.shade200.withAlpha(100);
  }
  Color appBackgroundColor ({
    required BuildContext context
  }) {
    // bool darkMode = context.watch<ColorModeChoiceProvider>().darkMode;
    // if(darkMode) return Colors.black;
    return Colors.white;
  }

  Color appButtonBackgroundColor ({
    required BuildContext context
  }) {
  //  bool darkMode = context.watch<ColorModeChoiceProvider>().darkMode;
  //   if(darkMode) return Colors.grey.shade200;
    return Colors.black;
  }

  Color appButtonContentColor ({
    required BuildContext context
  }) {
    // bool darkMode = context.watch<ColorModeChoiceProvider>().darkMode;
    // if(darkMode) return Colors.black;
    return Colors.grey.shade200;
  }
  
  Color appForgroundColor ({
    required BuildContext context
  }) {
    return Colors.grey.shade200;
  }
  Color appTextColor ({
    required BuildContext context
  }) {
    // bool darkMode = context.watch<ColorModeChoiceProvider>().darkMode;
    // if(darkMode == true) return Colors.white;
    return Colors.black;
  }

  Color appTextColorGrey ({
    required BuildContext context
  }) {
    // bool darkMode = context.watch<ColorModeChoiceProvider>().darkMode;
    // if(darkMode == true) return Colors.grey;
    return Colors.grey.shade600;
  }

  Color grey() {
    return Colors.grey.shade300;
  }

  Color eventSettingContainerColor({
    required BuildContext context
  }) {
    // bool darkMode = context.watch<ColorModeChoiceProvider>().darkMode;
    // if(darkMode == true) return Colors.white12;
    return Colors.black12;
  }

  Color billingAccentColor ({
    required BillType billType
  }) {
    if(billType == BillType.inHouse) {
      return Colors.purple.shade400;
    } else if(billType == BillType.delivery) {
      return Colors.blue;
    } else {
      return Colors.orange;
    }
  }

  Color billTileColor ({
    required BillType billType
  }) {
    if(billType == BillType.inHouse) {
      return Colors.purple.shade400;
    } else if(billType == BillType.delivery) {
      return Color.fromARGB(255, 181, 216, 244);
    } else {
      return Color.fromARGB(255, 245, 227, 201);
    }
  }
}

