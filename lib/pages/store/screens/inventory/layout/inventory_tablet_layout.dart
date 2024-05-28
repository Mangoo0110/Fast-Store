

import 'package:easypos/pages/store/screens/inventory/widgets/product_and_category_list.dart';
import 'package:flutter/material.dart';

class InventoryTabletLayOut extends StatelessWidget {
  const InventoryTabletLayOut({super.key});

  

  @override
  Widget build(BuildContext context) {
    
    return LayoutBuilder(
      builder: (context, constraints) {
        return const Column(
          children: [
             Flexible(child: CategoryAndProductList()),
          ],
        );
      },
    );
  }
}