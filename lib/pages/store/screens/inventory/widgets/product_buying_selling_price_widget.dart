import 'package:easypos/common/data/app_regexp.dart';
import 'package:easypos/common/widgets/num_textfield.dart';
import 'package:easypos/models/product_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class ProductBuyingSellingPrice extends StatefulWidget {
  final ProductModel product;
  final Function (ProductModel afterEditProduct) afterEditProduct;
  const ProductBuyingSellingPrice({super.key, required this.product, required this.afterEditProduct});

  @override
  State<ProductBuyingSellingPrice> createState() => _ProductBuyingSellingPriceState();
}

class _ProductBuyingSellingPriceState extends State<ProductBuyingSellingPrice> {

  final _productPriceformKey = GlobalKey<FormState>();

  final _productionCostformKey = GlobalKey<FormState>();

  TextEditingController productPriceInputcontroller = TextEditingController();

  TextEditingController productionCostInputcontroller = TextEditingController();

  // double
  double productPrice = 0.0, productionCost = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    productPrice = widget.product.productPrice;
    productionCost = widget.product.productionCost;
    productPriceInputcontroller.text = productPrice.toString();
    productionCostInputcontroller.text = productionCost.toString();
    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Table(
          columnWidths: const {0: FlexColumnWidth(.5), 1: FlexColumnWidth(.5)},
          children: [
            TableRow(
              children: [
                _sellingPrice(),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: _productionCost(),
                )
              ]
            )
          ],
        );
      }
    );
  }

  

  Widget _sellingPrice() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: 75,
          child: Form(
            key: _productPriceformKey,
            child: NumTextfield(
              onTap: () {
                
              },
              maxLines: 1,
              onlyInteger: false,
              numRegExp: moneyRegExp(),
              onChanged: (text) {
                if (mounted) {
                  _productPriceformKey.currentState!.validate();
                }
              },
              controller: productPriceInputcontroller,
              hintText: 'Price of the product per unit',
              labelText: "Product price",
              validationCheck: (text) {
                if (text.isEmpty) {
                  return "This field can not be empty";
                }
                if (!integerRegExp().hasMatch(text)) {
                  productPriceInputcontroller.text =
                      productPrice.toString();
                  return "Not a valid price (e.g. 0.123, 100000, 209, 25.8773) ";
                } else {
                  double? price = double.tryParse(text);
                  if (price != null) {
                    productPrice = price;
                    widget.product.productPrice = price;
                    widget.afterEditProduct(widget.product);
                  } else {
                    productPriceInputcontroller.text =
                        productPrice.toString();
                    return "Not a valid price (e.g. 0.123, 100000, 209, 25.8773) ";
                  }
                }
                return null;
              },
            ),
          ),
        );
      },
    );
  }

  Widget _productionCost() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: 75,
          child: Form(
            key: _productionCostformKey,
            child: NumTextfield(
              onTap: () {
                
              },
              maxLines: 1,
              onlyInteger: false,
              numRegExp: moneyRegExp(),
              onChanged: (text) {
                if (mounted) {
                  _productionCostformKey.currentState!.validate();
                }
              },
              controller: productionCostInputcontroller,
              hintText: 'Type valid number',
              labelText: "Production Cost/ Buying Cost",
              validationCheck: (text) {
                if (text.isEmpty) {
                  return "This field can not be empty";
                }
                if (!integerRegExp().hasMatch(text)) {
                  productionCostInputcontroller.text =
                      productionCost.toString();
                  return "Not a valid price (e.g. 0.123, 100000, 209, 25.8773) ";
                } else {
                  double? price = double.tryParse(text);
                  if (price != null) {
                    productionCost = price;
                    widget.product.productionCost = price;
                    widget.afterEditProduct(widget.product);
                  } else {
                    productionCostInputcontroller.text =
                        productionCost.toString();
                    return "Not a valid price (e.g. 0.123, 100000, 209, 25.8773) ";
                  }
                }
                return null;
              },
            ),
          ),
        );
      },
    );
  }
}