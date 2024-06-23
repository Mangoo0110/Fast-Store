import 'package:easypos/common/widgets/image_related/show_round_image.dart';
import 'package:easypos/models/bill_model.dart';
import 'package:easypos/models/billing_product.dart';
import 'package:easypos/pages/store/controller/store_data_controller.dart';
import 'package:easypos/pages/store/screens/billing/controller/billing_data_controller.dart';
import 'package:easypos/pages/store/screens/billing/screen/checkout/checkout_layout.dart';
import 'package:easypos/pages/store/screens/billing/widgets/billing_product_edit_popup.dart';
import 'package:easypos/utils/app_colors.dart';
import 'package:easypos/utils/app_sizes.dart';
import 'package:easypos/utils/app_textstyles.dart';
import 'package:easypos/utils/dekhao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class BilledProductListWidget extends StatelessWidget {
  final List<BillingProduct>  billedProductList;
  const BilledProductListWidget({super.key, required this.billedProductList});

  @override
  Widget build(BuildContext context) {
    
    return LayoutBuilder(
      builder: (context, constraints) {
        List<Widget> widgetList = [];
        for(int index = 0; index < billedProductList.length; index++) {
          widgetList.add(Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Container(
              height: 80,
              width: constraints.maxWidth,
              decoration: BoxDecoration(
                color: index % 2 == 0 ? AppColors().grey().withOpacity(.5) : Colors.transparent,
                borderRadius: BorderRadius.circular(8)
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    showModalBottomSheet(
                      context: context, 
                      builder:(context) => BillingProductEditPopup(
                        billingProduct: billedProductList[index],
                        onDone: (quantity, discountPercentage) {

                          context.read<BillingDataController>()
                          .productDiscount(
                            discountPercentage: discountPercentage, 
                            productId: billedProductList[index].productId);

                          context.read<BillingDataController>()
                          .editSoldUnitOfProduct(
                            handTypedSoldUnit: quantity, 
                            productId: billedProductList[index].productId, 
                            billigMethod: billedProductList[index].billingMethod);
                          Navigator.pop(context);
                        }));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: _table(context: context, constraints: constraints, billingProduct: billedProductList[index]),
                  ),
                ),
              ),
            ),
          ));
        }
        return SafeArea(
          child: (billedProductList.isEmpty) ? 
          const Center(child: Text('No products selected!'))
          :
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widgetList,
          ),
        );
      },
    );
  }

  Widget _table({required BuildContext context, required BoxConstraints constraints, required BillingProduct billingProduct,}) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: const{0: FlexColumnWidth(.62), 1: FlexColumnWidth(.38),},
      children: [
        TableRow(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShowRoundImage(image: context.read<StoreDataController>().imageIfExist(imageId: billingProduct.productImageId), height: 60, width: 60, borderRadius: 5000000,),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(child: Text(billingProduct.productName, style: AppTextStyle().normalSize(context: context),)),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 3.0),
                            child: Text('Qty. ${billingProduct.quantity}', style: AppTextStyle().greySmallSize(context: context),),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topRight, 
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(child: Text("${billingProduct.totalPrice.toString()} Tk", style: AppTextStyle().normalSize(context: context),)),
                  (billingProduct.discountPercentage <=0) ?
                  Container()
                  :
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        "${(billingProduct.totalPrice + (billingProduct.quantity * billingProduct.productPrice) * (billingProduct.discountPercentage / 100)).toString()} Tk", 
                        style: TextStyle(
                          color: AppColors().appTextColor(context: context).withOpacity(.3), 
                          fontSize: AppSizes().normalText, 
                          fontWeight: FontWeight.bold, 
                          decoration: TextDecoration.lineThrough, 
                          decorationColor:  AppColors().appTextColor(context: context).withOpacity(.6),
                          decorationThickness: 2)),
                    ),
                  ),
                ],
              ))
          ]
        )
      ],
    );
  }

}