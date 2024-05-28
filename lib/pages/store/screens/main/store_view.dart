import 'dart:async';
import 'dart:math';
import 'package:easypos/models/category_list_model.dart';
import 'package:easypos/models/product_model.dart';
import 'package:easypos/models/store_model.dart';
import 'package:easypos/pages/store/controller/store_data_controller.dart';
import 'package:easypos/pages/store/screens/appdrawer/controller/appdrawer_controller.dart';
import 'package:easypos/pages/store/screens/appdrawer/screens/appdrawer.dart';
import 'package:easypos/pages/store/widgets/app_drawer_screens.dart';
import 'package:easypos/pages/store/widgets/appbar_title.dart';
import 'package:easypos/pages/user_auth/screens/signin.dart';
import 'package:easypos/utils/app_colors.dart';
import 'package:easypos/utils/app_textstyles.dart';
import 'package:easypos/utils/dekhao.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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


  // functions

  // data(){
  //   context.read<DataProviderOfStore>().fetchCategoriesOfStore(_categoryStreamController);
  //   context.read<DataProviderOfStore>().fetchProductListOfStore(_productListStreamController);
  // }

  @override
  void initState() {
    
    if(mounted) {
     //data();
      // Future.delayed(const Duration(seconds: 2), () async{
      //   await context.read<DataProviderOfStore>().init(context: context);
      // });
      // _fetchCategoriesOfStore();
      // _fetchProductListOfStore();
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // _categoryStreamController.close();
    // _productListStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //context.read<DataProviderOfStore>().init(context: context);
    return LayoutBuilder(
      builder: (context, constraints) {
        // return Scaffold(
        //   appBar: AppBar(
        //     title: const AppbarTitleWidget()
        //   ),
        //   drawer: AppDrawer(
        //     selectedTab: _appDrawerTabState,
        //     onNewTabSelect: (selectedAppDrawerTab) {
        //       context.read<AppdrawerProviderController>().changeAppDrawerTab(selectedAppDrawerTab);
        //     },
        //   ),
        //   body: const AppDrawerScreens()
        // );

        return FutureBuilder(
          future: context.read<StoreDataController>().init(context: context),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.done || ConnectionState.active:
                //currentStore = snapshot.data;
                currentStore = context.read<StoreDataController>().currentStore;
                if(currentStore != null) {
                  dekhao(currentStore!.toMap().toString());
                } else {
                  dekhao("currentStore == null");
                }
                return Scaffold(
                  appBar: AppBar(
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
                // dekhao(snapshot.data)
              default:
                return Container();
            }
          }
        );
        
        // return FutureBuilder(
        //   future: context.read<DataProviderOfStore>().getCurrentStore(context: context),
        //   builder: (context, snapshot) {
        //     switch (snapshot.connectionState) {
        //       case ConnectionState.waiting:
        //         return const Center(child: CircularProgressIndicator());
        //       case ConnectionState.done || ConnectionState.active:
        //         currentStore = snapshot.data;
        //         // dekhao(snapshot.data)
        //         if(currentStore != null) {
        //           dekhao("has data");
        //           data();
        //           return StreamBuilder(
        //             stream: _categoryStreamController.stream,
        //             builder: (context, snapshot) {
        //               switch (snapshot.connectionState) {
        //                 case ConnectionState.waiting:
        //                   return const Center(child: CircularProgressIndicator());
        //                 case ConnectionState.done || ConnectionState.active:
        //                   if(snapshot.hasData) {
        //                     //categoryMapListOfStore = snapshot.data! ;
        //                     return StreamBuilder(
        //                       stream: _productListStreamController.stream,
        //                       builder: (context, productListSnapshot) {
        //                         switch (productListSnapshot.connectionState) {
        //                           case ConnectionState.waiting:
        //                             return const Center(child: CircularProgressIndicator());
        //                           case ConnectionState.done || ConnectionState.active:
        //                             if(productListSnapshot.hasData) {
        //                               List<ProductModel> productList = productListSnapshot.data ?? [];
        //                               if(productList.isEmpty) {
        //                                 return Expanded(
        //                                   child: Container(
        //                                     height: min(constraints.maxHeight, 100),
        //                                     decoration: BoxDecoration(
        //                                       color: AppColors().grey(),
        //                                       borderRadius: BorderRadius.circular(8)
        //                                     ),
        //                                     child: Center(
        //                                       child: Text(
        //                                         'No products to show!', style: AppTextStyle().greyBoldNormalSize(context: context),
        //                                       ),
        //                                     ),
        //                                   ),
        //                                 );
        //                               } else {
        //                                 return Scaffold(
        //                                   appBar: AppBar(
        //                                     title: const AppbarTitleWidget()
        //                                   ),
        //                                   drawer: AppDrawer(
        //                                     selectedTab: _appDrawerTabState,
        //                                     onNewTabSelect: (selectedAppDrawerTab) {
        //                                       context.read<AppdrawerProviderController>().changeAppDrawerTab(selectedAppDrawerTab);
        //                                     },
        //                                   ),
        //                                   body: const AppDrawerScreens()
        //                                 );
        //                                 //_populateCategoryMappedProductList(productList);
        //                                 // return FutureBuilder(
        //                                 //   future: getImages(),
        //                                 //   builder: (context, snapshot) {
        //                                 //     switch (snapshot.connectionState) {
        //                                 //       case ConnectionState.waiting:
        //                                 //         return const Center(child: CircularProgressIndicator());
        //                                 //       case ConnectionState.done || ConnectionState.active:
        //                                 //         final Map<String, Uint8List?> idMappedImages = snapshot.data ?? {};
                                                
        //                                 //       default: 
        //                                 //         return const Center(child: CircularProgressIndicator());
        //                                 //     }
        //                                 //   },
        //                                 // );
                                        
        //                               }
        //                             } else {
        //                               return const Expanded(child: Center(child: Text('No products!!')));
        //                             }
        //                           default: 
        //                             return const Center(child: CircularProgressIndicator());
        //                         }
        //                       },
        //                     );
        //                   } else {
        //                     return const Expanded(child: Center(child: Text('No categories and products!!')));
        //                   }
        //                 default: 
        //                   dekhao('category waiting111');
        //                   return const Center(child: CircularProgressIndicator());
        //               }
        //             },
        //           );
                   
        //         } else {
        //           dekhao("has no data");
        //           return Scaffold(appBar: AppBar(), body: const Center(child: Text("No Store found")));
        //         }
        //       default: 
        //         return const Center(child: CircularProgressIndicator()); 
        //     }
        //   }
        // );
      },
    );
  }
  
}