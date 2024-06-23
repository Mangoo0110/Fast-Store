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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BilledProductListTabletWidget extends StatelessWidget {
  const BilledProductListTabletWidget({super.key});



  @override
  Widget build(BuildContext context) {
    final BillModel currentBill = context.watch<BillingDataController>().currentBill!;
    final List<BillingProduct>  billedProductList = currentBill.idMappedBilledProductList.entries.map((billingProduct) {
      return billingProduct.value;
    }).toList();
    return LayoutBuilder(
      builder: (context, constraints) {
        dekhao("BilledProductListTabletWidget height ${constraints.maxHeight.toString()}");
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [

            Flexible(
              child: SizedBox(
                //height: 150,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: (currentBill.idMappedBilledProductList.isEmpty) ? 
                  const Center(child: Text('No products selected!'))
                  :
                  ListView.builder(
                    itemCount: billedProductList.length,
                    itemBuilder: (BuildContext context, int index) {  
                      final billingProduct = billedProductList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Container(
                          height: 80,
                          width: constraints.maxWidth,
                          decoration: BoxDecoration(
                            color: index % 2 == 0 ? AppColors().grey() : Colors.transparent,
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
                                    billingProduct: billingProduct,
                                    onDone: (quantity, discountPercentage) {
                                      context.read<BillingDataController>().productDiscount( discountPercentage: discountPercentage, productId: billingProduct.productId);
                                      context.read<BillingDataController>().editSoldUnitOfProduct(handTypedSoldUnit: quantity, productId: billingProduct.productId, billigMethod: BillingMethod.itemSelect);
                                      Navigator.pop(context);
                                    }));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: _table(context: context, constraints: constraints, billingProduct: billingProduct),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  )
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors().appActionColor(context: context),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.green,
                  onTap: () {
                    Future.delayed(const Duration(milliseconds: 500)).then((value) {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const CheckoutLayout()));
                    });
                    
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Pay', style: TextStyle(color: Colors.white,),),
                        Text("${currentBill.payableAmount.toString()} Tk.", style: TextStyle(color: Colors.white, fontSize: AppSizes().extraBig, overflow: TextOverflow.ellipsis),)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
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