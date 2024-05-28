

import 'package:easypos/pages/store/screens/inventory/widgets/product_and_category_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class InventoryMobileLayOut extends StatelessWidget {
  const InventoryMobileLayOut({super.key});

  

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