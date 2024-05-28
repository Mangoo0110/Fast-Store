
import 'package:easypos/pages/store/screens/analysis/layout/analysis_main.dart';
import 'package:easypos/pages/store/screens/appdrawer/controller/appdrawer_controller.dart';
import 'package:easypos/pages/store/screens/appdrawer/screens/appdrawer.dart';
import 'package:easypos/pages/store/screens/billing/screen/billing_main.dart';
import 'package:easypos/pages/store/screens/inventory/layout/inventory_main.dart';
import 'package:easypos/pages/store/screens/settings/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawerScreens extends StatelessWidget {
  
  const AppDrawerScreens({super.key,});

  

  @override
  Widget build(BuildContext context) {
    AppDrawerTabState appDrawerTabState = AppDrawerTabState.billing;
    appDrawerTabState = context.watch<AppdrawerProviderController>().selectedAppDrawerTab;
    if(appDrawerTabState == AppDrawerTabState.billing) {
      return const BillingMain();
    } else if(appDrawerTabState == AppDrawerTabState.analysis) {
      return const AnalysisMain();
    } else if(appDrawerTabState == AppDrawerTabState.inventory) {
      return const InventoryMain();
    } else if(appDrawerTabState == AppDrawerTabState.settings) {
      return const SettingsLayout();
    } else {
      return const BillingMain();
    }
  }
}