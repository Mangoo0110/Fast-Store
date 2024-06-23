import 'package:easypos/models/category_list_model.dart';
import 'package:easypos/models/product_model.dart';
import 'package:easypos/pages/store/controller/store_data_controller.dart';
import 'package:easypos/pages/store/screens/billing/widgets/products_grid_view_widget.dart';
import 'package:easypos/utils/app_colors.dart';
import 'package:easypos/utils/app_textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class SelectProductItemsWidget extends StatefulWidget {
  const SelectProductItemsWidget({super.key});

  @override
  State<SelectProductItemsWidget> createState() => _SelectProductItemsWidgetState();
}

class _SelectProductItemsWidgetState extends State<SelectProductItemsWidget> {
  String selectedCategoryName = 'All products';

  Map<String, List<ProductModel>> categoryMappedProductList = {};

  final Map<String, ProductModel> idMappedProducts = {};

  late CategoryMapListModel categoryMapListOfStore;

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
            Row(
              children: [
                _categories(constraints: constraints),
                Flexible(child: _quickProductButton()),
              ],
            ),
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
      //width: constraints.maxWidth,
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
  }

  Widget _quickProductButton() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: 50,
          width: constraints.maxWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(color: Color(0x1F000000), blurRadius: 5)
            ]
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                
              },
              child: Center(
                child: Text(
                  "Quick Products", style: AppTextStyle().boldSmallSize(context: context),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _categoryProducts({required String categoryName, required List<ProductModel> productList, required BoxConstraints constraints,}) {
    return ProductGridViewWiget(productList: productList);
  }

}