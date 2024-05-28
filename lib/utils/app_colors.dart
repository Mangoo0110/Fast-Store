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
    return  Colors.orange.shade800;
  }
  Color appAccentColor ({
    required BuildContext context
  }) {
    return Colors.blueAccent.shade100;
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
}

