import 'dart:typed_data';
import 'package:easypos/common/widgets/image_related/show_rect_image.dart';
import 'package:easypos/models/product_model.dart';
import 'package:easypos/pages/store/controller/store_data_controller.dart';
import 'package:easypos/pages/store/screens/inventory/controller/inventory_data_controller.dart';
import 'package:easypos/pages/store/screens/inventory/screens/create_or_update_product.dart';
import 'package:easypos/utils/app_colors.dart';
import 'package:easypos/utils/app_sizes.dart';
import 'package:easypos/utils/app_textstyles.dart';
import 'package:easypos/utils/dekhao.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryAndProductList extends StatefulWidget {
  const CategoryAndProductList({super.key,});

  @override
  State<CategoryAndProductList> createState() => _CategoryAndProductListState();
}

class _CategoryAndProductListState extends State<CategoryAndProductList> {
  String selectedCategoryName = 'All products';

  Map<String, List<ProductModel>> categoryMappedProductList = {};




  
  //functions 

  
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
    //_populateCategoryMappedProductList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _populateCategoryMappedProductList();
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Align(alignment: Alignment.topLeft, child: _categories(constraints: constraints)),
            ),
            Flexible(child: _categoryProducts(categoryName: selectedCategoryName, productList: categoryMappedProductList[selectedCategoryName] ?? [], constraints: constraints))
          ],
        );
      },
    );
  }

  Widget _categories({required BoxConstraints constraints}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: context.watch<StoreDataController>().categoryMapImageIdOfStore.entries.map((categoryMappedImageId) {
          return Padding(
            padding: const EdgeInsets.only(right: 3),
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
                      style: TextStyle(color: selectedCategoryName == categoryMappedImageId.key ? Colors.white : Colors.black, fontSize: AppSizes().normalText),),
                  ),
                ),
              )
            ),
          );
        }).toList()
      ),
    );
  }

  Widget _categoryProducts({required String categoryName, required List<ProductModel> productList, required BoxConstraints constraints}) {
    dekhao(constraints.maxWidth / 2);
    if(productList.isEmpty) {
      return Text('0 products', style: AppTextStyle().greyBoldNormalSize(context: context),);
    }
    return ListView.builder(
      itemCount: productList.length,
      itemBuilder: (context, index) {
        ProductModel thisProduct = productList[index];
        Uint8List? thisProductImage = context.watch<StoreDataController>().idMappedImages[thisProduct.productImageId];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Container(
            height: 100,
            width: constraints.maxWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: index % 2 == 0 ? Colors.white : Colors.grey.shade200,
              // border: Border.all(color: AppColors().grey()),
              // //border: Border.all(color: Colors.grey),
              // boxShadow: const [
              //   BoxShadow(color: Color(0x1F000000), blurRadius: 5)
              // ]
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(4),
                onTap: () {
                  
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> CreateOrUpdateProduct(
                    productImage: thisProductImage,
                    heroTagForImage: thisProduct.productId,
                    updatingProduct: thisProduct,
                    onCreateDone: () {
                      Navigator.pop(context);
                    },
                  )));
                  
                },
                onLongPress: () {
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            thisProduct.productName, 
                            style: AppTextStyle().normalSize(context: context)
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              "(${thisProduct.productPrice} Tk)", 
                              style: TextStyle(color: Colors.orange.shade500, fontSize: AppSizes().normalText, fontWeight: FontWeight.bold)
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const  EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      child: ShowRectImage(image: thisProductImage, height: 90, width: 90, borderRadius: 8,)
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

}