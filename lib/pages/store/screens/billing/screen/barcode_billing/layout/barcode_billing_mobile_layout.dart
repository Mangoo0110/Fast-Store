import 'package:easypos/common/widgets/show_round_image.dart';
import 'package:easypos/models/bill_model.dart';
import 'package:easypos/models/billing_product.dart';
import 'package:easypos/models/product_model.dart';
import 'package:easypos/pages/store/controller/store_data_controller.dart';
import 'package:easypos/pages/store/screens/billing/controller/billing_data_controller.dart';
import 'package:easypos/pages/store/screens/billing/screen/calculator_billing/calculator_billing_layout.dart';
import 'package:easypos/pages/store/screens/billing/screen/item_select_billing/item_select_billing_layout.dart';
import 'package:easypos/pages/store/screens/billing/widgets/barcode_widget.dart';
import 'package:easypos/pages/store/screens/billing/widgets/billed_product_list_widget.dart';
import 'package:easypos/pages/store/screens/billing/widgets/billing_product_edit_popup.dart';
import 'package:easypos/pages/store/screens/billing/widgets/calculator_widget.dart';
import 'package:easypos/pages/store/screens/billing/widgets/select_product_items_widget.dart';
import 'package:easypos/pages/store/screens/billing/widgets/short_overview_of_bill_widget.dart';
import 'package:easypos/utils/app_colors.dart';
import 'package:easypos/utils/app_textstyles.dart';
import 'package:easypos/utils/dekhao.dart';
import 'package:easypos/utils/routing/smooth_page_transition.dart';
import 'package:easypos/utils/app_sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class BarcodeBillingMobileLayout extends StatefulWidget {
  final BillModel bill;
  const BarcodeBillingMobileLayout({super.key, required this.bill});

  @override
  State<BarcodeBillingMobileLayout> createState() => _BarcodeBillingMobileLayoutState();
}

class _BarcodeBillingMobileLayoutState extends State<BarcodeBillingMobileLayout> {
  
  ScrollController _scrollController = ScrollController();

  ProductModel? getBarcodeProduct(String barcodeText){
    final index = context.read<StoreDataController>().productListOfStore.indexWhere((element) => element.itemBarcode == barcodeText);
    if(index < 0) return null;
    return context.read<StoreDataController>().productListOfStore[index];
  }

  _scrollTo({required GlobalKey key}) {
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCirc);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: AppColors().appActionColor(context: context),
              title: Text('Scan Barcode', style: TextStyle(color: Colors.white, fontSize: AppSizes().normalText, fontWeight: FontWeight.bold),),
              actions: _actionBarOptionList(),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  //flex: 200,
                  child: _scannedProducts()),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BarcodeWidget(
                    onGettingBarcode: (barcodeText) {
                      final barcodeProduct = getBarcodeProduct(barcodeText);
                      if(barcodeProduct == null) {
                        Fluttertoast.showToast(msg: 'Product not found!');
                        return;
                      }
                      context.read<BillingDataController>()
                      .addScannedBillingProduct(
                        billId: widget.bill.billId, 
                        product: barcodeProduct, addingUnit: 1,);
                    },
                  )
                ),
                Container( 
                  height: 120,
                  width: constraints.maxWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Colors.white,
                    boxShadow: const[
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 3
                      )
                    ]
                    //color: AppColors().grey(),
                  ),
                  child: ShortOverviewOfBillWidget(billId: widget.bill.billId)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _scannedProducts() {
    List<BillingProduct> scannedBillingProducts = [];
    List<GlobalKey> scannedProductsKey = [];
    context.watch<BillingDataController>()
    .inStoreBillQueue[widget.bill.billId]!
    .idMappedBilledProductList.forEach((key, billingProduct) {
      if(billingProduct.billingMethod == BillingMethod.scan) {
        dekhao(billingProduct.toMap());
        scannedBillingProducts.add(billingProduct);
      }
      scannedProductsKey.add(GlobalKey());
    },);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.all(6.0),
          child: BilledProductListWidget(
            billedProductList: scannedBillingProducts, billId: widget.bill.billId),
        );
        
      },
    );
  }

  List<Widget> _actionBarOptionList(){
    return [
      Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            Navigator.of(context).pushReplacement(SmoothPageTransition().createRoute(secondScreen: CalculatorBillingLayout(bill: widget.bill)));
          },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.calculate, color: Colors.white,),
          )),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 2.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              Navigator.of(context).pushReplacement(SmoothPageTransition().createRoute(secondScreen: ItemSelectBillingLayout(bill: widget.bill)));
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.inventory_outlined, color: Colors.white,),
            )),
        ),
      ),
      
    ];
  }

}