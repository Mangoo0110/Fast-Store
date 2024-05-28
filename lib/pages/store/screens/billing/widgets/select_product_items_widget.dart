import 'dart:typed_data';
import 'package:easypos/common/widgets/show_rect_image.dart';
import 'package:easypos/data/datasources/firebase/firebase_image_repo_impl.dart';
import 'package:easypos/models/category_list_model.dart';
import 'package:easypos/models/product_model.dart';
import 'package:easypos/pages/store/controller/store_data_controller.dart';
import 'package:easypos/pages/store/screens/billing/controller/billing_data_controller.dart';
import 'package:easypos/utils/app_colors.dart';
import 'package:easypos/utils/app_textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectProductItemsWidget extends StatefulWidget {
  final String billId;
  const SelectProductItemsWidget({super.key, required this.billId});

  @override
  State<SelectProductItemsWidget> createState() => _SelectProductItemsWidgetState();
}

class _SelectProductItemsWidgetState extends State<SelectProductItemsWidget> {
  String selectedCategoryName = 'All products';

  Map<String, List<ProductModel>> categoryMappedProductList = {};

  final Map<String, ProductModel> idMappedProducts = {};



  late CategoryMapListModel categoryMapListOfStore;

  
  //functions 

  Future<Uint8List?> getImage(String imageId) async{
    Uint8List? thisImage;
    await FirebaseImageRepoImpl().fetchImage(imageId: imageId)
    .then((dataResult) {
        dataResult
          .fold(
            (dataFailure) {
              //Fluttertoast.showToast(msg: "Failed! \n ${dataFailure.message}");
            } ,
            (fetchedImage) {
              thisImage = fetchedImage;
            }
          );
      });
    return thisImage;
  }

  // functions
  
  _populateCategoryMappedProductList() {
    List<ProductModel> productList = context.watch<StoreDataController>().productListOfStore;
    categoryMappedProductList = {};
    for(final ProductModel product in productList) {
      for(final String category in product.productCategoryList) {
        if(!categoryMappedProductList.containsKey(category)) {
          categoryMappedProductList[category] = [];
        }
        categoryMappedProductList[category]!.add(product);
      }
      if(!categoryMappedProductList.containsKey('All products')) {
          categoryMappedProductList['All products'] = [];
        }
      categoryMappedProductList['All products']!.add(product);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _populateCategoryMappedProductList();
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          // crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(alignment: Alignment.topLeft, child: _categories(constraints: constraints)),
            Flexible(child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: _categoryProducts(categoryName: selectedCategoryName, productList: categoryMappedProductList[selectedCategoryName] ?? [], constraints: constraints),
            ))
          ],
        );
      },
    );
  }

  Widget _categories({required BoxConstraints constraints}) {
    return Container(
      height: 50,
      width: constraints.maxWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors().grey()),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Color(0x1F000000), blurRadius: 5)
        ]
      ),
      child: Material(
            color: Colors.transparent,
            child: DropdownButton(
              borderRadius: BorderRadius.circular(8),
              isDense: true,
              enableFeedback: true,
              underline: Container(),
              //isExpanded: true,
              padding: const EdgeInsets.all(8),
              hint: Text(selectedCategoryName, style: AppTextStyle().boldNormalSize(context: context),),
              onChanged: (categoryName) {
                if(categoryName != null) {
                  setState(() {
                    selectedCategoryName = categoryName;
                  });
                }
              },
              items: context.watch<StoreDataController>().categoryMapImageIdOfStore.entries.map((categoryMappedImageId) {
                return DropdownMenuItem(
                  value: categoryMappedImageId.key, 
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    child: Text(categoryMappedImageId.key, style: AppTextStyle().normalSize(context: context),),
                  ), 
                );
              }
            ).toList()),
          ),
    );
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: context.watch<StoreDataController>().categoryMapImageIdOfStore.entries.map((categoryMappedImageId) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.5),
            child: InkWell(
              borderRadius: BorderRadius.circular(80000),
              onTap: () {
                setState(() {
                  selectedCategoryName = categoryMappedImageId.key;
                });
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(80000),
                  color: selectedCategoryName == categoryMappedImageId.key ? Colors.black : Colors.white,
                  border: Border.all(color: AppColors().grey()),
                  // border: Border.all(color: Colors.grey),
                  // boxShadow: const [
                  //   BoxShadow(color: Color(0x1F000000), blurRadius: 5)
                  // ]
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Center(
                    child: Text(
                      categoryMappedImageId.key, 
                      style: TextStyle(
                        color: selectedCategoryName == categoryMappedImageId.key ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              )
            ),
          );
        }).toList()
      ),
    );
    
  }

  Widget _categoryProducts({required String categoryName, required List<ProductModel> productList, required BoxConstraints constraints,}) {
    if(productList.isEmpty) {
      return Text('0 products', style: AppTextStyle().greyBoldNormalSize(context: context),);
    }
    return GridView.builder(
      itemCount: productList.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 170,
        childAspectRatio: 4 / 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ), 
      itemBuilder:(context, index) {
        ProductModel thisProduct = productList[index];
        Uint8List? thisProductImage = context.watch<StoreDataController>().idMappedImages[thisProduct.productImageId];
        return InkWell(
          onTap: () {
            context.read<BillingDataController>().addBillingProduct(billId: widget.billId, product: thisProduct, addingUnit: 1, discountPercentage: 0);
          },
          
          child: Container(
            //height: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(color: Color(0x1F000000), blurRadius: 5)
              ]
              //border: Border.all(color: Colors.black)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShowRectImage(
                  image: thisProductImage, 
                  height: constraints.maxWidth / (constraints.maxWidth / 200).ceil() * .4, 
                  width: constraints.maxWidth,
                  borderRadius: 8,
                  ),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      //color: AppColors().grey(),
                      
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              thisProduct.productName, 
                              style: AppTextStyle().normalSize(context: context)
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                "${thisProduct.productPrice} Tk", 
                                style: AppTextStyle().actionBoldNormalSize(context: context)
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

}