import 'package:easypos/common/widgets/show_round_image.dart';
import 'package:easypos/models/bill_model.dart';
import 'package:easypos/models/billing_product.dart';
import 'package:easypos/pages/store/controller/store_data_controller.dart';
import 'package:easypos/pages/store/screens/billing/controller/billing_data_controller.dart';
import 'package:easypos/pages/store/screens/billing/screen/invoice/invoice_layout.dart';
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
  final String billId;
  const BilledProductListWidget({super.key, required this.billId});



  @override
  Widget build(BuildContext context) {
    final BillModel bill = context.watch<BillingDataController>().inStoreBillQueue[billId]!;
    final List<BillingProduct>  billedProductList = bill.idMappedBilledProductList.entries.map((billingProduct) {
      return billingProduct.value;
    }).toList();
    return LayoutBuilder(
      builder: (context, constraints) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  Text('Subtotal: ', style: AppTextStyle().smallSize(context: context),),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text("${bill.subTotal.toString()} Tk", style: AppTextStyle().boldXtraBigSize(context: context),),
                  )
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(6),
              child: (bill.idMappedBilledProductList.isEmpty) ? 
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
                                billId: billId,
                                billingProduct: billingProduct,
                                onDone: (quantity) {
                                  dekhao("BillingProductEditPopup ${quantity.toString()}");
                                  context.read<BillingDataController>().editSoldUnitOfProduct(billId: billId, handTypedSoldUnit: quantity, productId: billingProduct.productId);
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
              children: [
                ShowRoundImage(image: context.read<StoreDataController>().imageIfExist(imageId: billingProduct.productImageId), height: 60, width: 60, borderRadius: 5000000,),
                Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(billingProduct.productName, style: AppTextStyle().normalSize(context: context),),
                      Padding(
                        padding: const EdgeInsets.only(top: 3.0),
                        child: Text('Qty. ${billingProduct.quantity}', style: AppTextStyle().greySmallSize(context: context),),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Align(alignment: Alignment.topRight, child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("${billingProduct.totalPrice.toString()} Tk", style: AppTextStyle().normalSize(context: context),),
                const Padding(
                  padding: EdgeInsets.only(left: 4.0),
                  child: Icon(Icons.cancel, color: Colors.black,),
                )
              ],
            ))
          ]
        )
      ],
    );
  }

}