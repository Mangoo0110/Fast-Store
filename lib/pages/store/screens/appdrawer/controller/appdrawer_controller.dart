import 'package:easypos/pages/store/screens/appdrawer/screens/appdrawer.dart';
import 'package:flutter/material.dart';

class AppdrawerProviderController extends ChangeNotifier {
  AppDrawerTabState _selectedAppDrawerTab = AppDrawerTabState.billing;

  AppDrawerTabState get selectedAppDrawerTab => _selectedAppDrawerTab;

  changeAppDrawerTab(AppDrawerTabState selectedAppDrawerTab) {
    _selectedAppDrawerTab = selectedAppDrawerTab;
    notifyListeners();
  }
}