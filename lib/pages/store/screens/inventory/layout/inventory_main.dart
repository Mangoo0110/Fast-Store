
import 'package:easypos/pages/store/screens/inventory/screens/create_category.dart';
import 'package:easypos/pages/store/screens/inventory/screens/create_or_update_product.dart';
import 'package:easypos/pages/store/screens/inventory/widgets/product_and_category_list.dart';
import 'package:easypos/utils/app_colors.dart';
import 'package:easypos/utils/app_sizes.dart';
import 'package:easypos/utils/app_textstyles.dart';
import 'package:flutter/material.dart';

class InventoryMain extends StatelessWidget {
  const InventoryMain({super.key});

  @override
  Widget build(BuildContext context) {
    
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> CreateOrUpdateProduct(
                      productImage: null,
                      heroTagForImage: 'none',
                      updatingProduct: null,
                      onCreateDone: () {
                        Navigator.pop(context);
                      },
                    )));
                  },
                  child: _appBarButton(icon: Icons.add, buttonText: "Product", context: context)),
                SizedBox(width: AppSizes().horizontalSpace1,),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> CreateCategory(
                      onCreateDone: () {
                        Navigator.pop(context);
                      },
                    )));
                  },
                  child: _appBarButton(icon: Icons.add, buttonText: "Category", context: context)),
                SizedBox(width: AppSizes().horizontalSpace1,),
                ],
              ),
              const Flexible(child: CategoryAndProductList()),
              // (constraints.maxWidth <= 600) ?
              // const Expanded(child: InventoryMobileLayOut())
              // :
              // const Expanded(child: InventoryTabletLayOut())
                                        
            ],
          ),
        );
        
        
      },
    );
  }

  Widget _appBarButton({required IconData icon, required String buttonText, required BuildContext context}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.grey.shade200,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors().appActionColor(context: context), weight: 20,),
            Padding(
              padding: const EdgeInsets.all(4),
              child: Text(buttonText, style: AppTextStyle().boldSmallSize(context: context),),
            )
          ],
        ),
      ),
    );
  }
}