import 'package:easypos/common/widgets/text_widgets.dart';
import 'package:easypos/pages/store/controller/store_data_controller.dart';
import 'package:easypos/pages/store/screens/billing/controller/billing_data_controller.dart';
import 'package:easypos/pages/store/screens/billing/screen/item_select_billing/item_select_billing_layout.dart';
import 'package:easypos/pages/store/screens/billing/screen/pages/dashboard_page.dart';
import 'package:easypos/pages/store/screens/billing/screen/pages/transaction_page.dart';
import 'package:easypos/utils/app_colors.dart';
import 'package:easypos/utils/app_sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class BillingMain extends StatefulWidget {
  const BillingMain({super.key});

  @override
  State<BillingMain> createState() => _BillingMainState();
}

class _BillingMainState extends State<BillingMain> {

  int selectedIndex = 0;
    
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          //backgroundColor: Colors.black,
          floatingActionButton: FloatingActionButton.extended(
            extendedIconLabelSpacing: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6), side: BorderSide(width: 1.5, color: AppColors().appActionColor(context: context))),
            backgroundColor: AppColors().appActionColor(context: context),
            icon: const Icon(Icons.add, color: Colors.white, ),
            label: TextWidgets().buttonText(buttonText: 'NEW BILL', textColor: Colors.white),
            onPressed:() {
              context.read<BillingDataController>().newBill(
                      storeId: context.read<StoreDataController>().currentStore!.storeId);
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context)=> const ItemSelectBillingLayout()
                )
              );
            },
          ),
          bottomNavigationBar: NavigationBar(
            //animationDuration: Duration(seconds: 1),
            height: 60,
            elevation: 50,
            indicatorColor: Colors.black.withOpacity(.20),
            
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.grey,
            selectedIndex: selectedIndex,
            onDestinationSelected: (value) {
              setState(() {
                selectedIndex = value;
              });
            },
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.dashboard_outlined,),
                selectedIcon: Icon(Icons.dashboard),
                label: 'Dashboard'
              ),
              NavigationDestination(
                icon: Icon(Icons.wysiwyg_outlined,),
                selectedIcon: Icon(Icons.wysiwyg),
                label: 'Transactions',
              )
            ],
          ),
          body: [const DashboardPage(), const TransactionPage()].elementAt(selectedIndex)
        );
      },
    );
  }

}