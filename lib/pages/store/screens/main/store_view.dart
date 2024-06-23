import 'package:easypos/models/category_list_model.dart';
import 'package:easypos/models/product_model.dart';
import 'package:easypos/models/store_model.dart';
import 'package:easypos/pages/store/screens/appdrawer/controller/appdrawer_controller.dart';
import 'package:easypos/pages/store/screens/appdrawer/screens/appdrawer.dart';
import 'package:easypos/pages/store/widgets/app_drawer_screens.dart';
import 'package:easypos/pages/store/widgets/appbar_title.dart';
import 'package:easypos/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoreView extends StatefulWidget {
  const StoreView({super.key});

  @override
  State<StoreView> createState() => _StoreViewState();
}

class _StoreViewState extends State<StoreView> {
  // final StreamController<Map<String, String>> _categoryStreamController = StreamController<Map<String, String>>();

  // final StreamController<List<ProductModel>> _productListStreamController = StreamController<List<ProductModel>>() ;

  late CategoryMapListModel categoryMapListOfStore;
  List<ProductModel> productListOfStore = [];

  StoreModel? currentStore;
  final AppDrawerTabState _appDrawerTabState = AppDrawerTabState.billing;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          backgroundColor: AppColors().appBackgroundColor(context: context),
          appBar: AppBar(
            backgroundColor: AppColors().appBackgroundColor(context: context),
            title: const AppbarTitleWidget(),
          ),
          drawer: AppDrawer(
            selectedTab: _appDrawerTabState,
            onNewTabSelect: (selectedAppDrawerTab) {
              context.read<AppdrawerProviderController>().changeAppDrawerTab(selectedAppDrawerTab);
            },
          ),
          body: const AppDrawerScreens()
        );
      },
    );
  }
  
}