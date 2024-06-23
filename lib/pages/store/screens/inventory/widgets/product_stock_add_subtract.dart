import 'package:easypos/models/product_model.dart';
import 'package:easypos/pages/store/screens/inventory/widgets/piece_kilo_switch_widget.dart';
import 'package:easypos/utils/app_sizes.dart';
import 'package:flutter/material.dart';

class ProductStockAddSubtractWidget extends StatefulWidget {
  final ProductModel product;
  final Function (ProductModel stockChangedProduct) onStockChange;
  const ProductStockAddSubtractWidget({super.key, required this.product, required this.onStockChange});

  @override
  State<ProductStockAddSubtractWidget> createState() => _ProductStockAddSubtractWidgetState();
}

class _ProductStockAddSubtractWidgetState extends State<ProductStockAddSubtractWidget> {

  //bool
  bool kiloLitreProduct = true, pieceProduct = false;

  final TextEditingController _controller = TextEditingController();

  double containerHeight = 50;

  @override
  void initState() {
    // TODO: implement initState
    kiloLitreProduct = widget.product.kiloLitreProduct;
    pieceProduct = ! kiloLitreProduct;
    _controller.text = widget.product.stockCount.toString();
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: PieceKiloSwitchWidget(
                kiloLitreProduct: kiloLitreProduct,
                pieceProduct: pieceProduct,
                pieceProductState: (state) {
                  pieceProduct = state;
                },
                kiloLitreProductState: (state) {
                  kiloLitreProduct = state;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SizedBox(
                height: containerHeight,
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: const {0: FlexColumnWidth(.33), 1: FlexColumnWidth(.33), 2: FlexColumnWidth(.33)},
                  children: [
                    TableRow(
                      children: [
                        _stockShow(), 
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: _addStock(),
                        ), 
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: _subtractStock(),
                        )
                      ]
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _stockShow() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
         height: containerHeight,
          width: constraints.maxWidth,
          child: TextField(
            controller: _controller,
            readOnly: true,
            maxLines: 1,
            decoration: InputDecoration(
              labelText: 'Stock',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Colors.black)
              )
            ),
          ),
        );
      },
    );
  }

  Widget _addStock() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: containerHeight,
          width: constraints.maxWidth,
          decoration: BoxDecoration(
            color: Colors.green.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    'Add', style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.bold, fontSize: AppSizes().small),
                  ),
                ),
              ),
            ),
          )
        );
      },
    );
  }

  Widget _subtractStock() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: containerHeight,
          width: constraints.maxWidth,
          decoration: BoxDecoration(
            color: Colors.red.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    'Subtract', style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.bold, fontSize: AppSizes().small),
                  ),
                ),
              ),
            ),
          )
        );
      },
    );
  }
}