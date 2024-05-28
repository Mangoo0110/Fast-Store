import 'package:easypos/utils/app_colors.dart';
import 'package:easypos/utils/app_textstyles.dart';
import 'package:easypos/utils/dekhao.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PieceKiloSwitchWidget extends StatefulWidget {
  final bool kiloLitreProduct;
  final bool pieceProduct;
  final void Function (bool state) kiloLitreProductState;
  final void Function (bool state) pieceProductState;
  const PieceKiloSwitchWidget({super.key, required this.kiloLitreProduct, required this.pieceProduct, required this.kiloLitreProductState, required this.pieceProductState});

  @override
  State<PieceKiloSwitchWidget> createState() => _PieceKiloSwitchWidgetState();
}

class _PieceKiloSwitchWidgetState extends State<PieceKiloSwitchWidget> {

  //bool
  bool kiloLitreProduct = true, pieceProduct = false;

  //functions

  @override
  void initState() {
    // TODO: implement initState
    pieceProduct = widget.pieceProduct;
    kiloLitreProduct = widget.kiloLitreProduct;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dekhao("pieceProduct $pieceProduct kiloLitreProduct $kiloLitreProduct");
    return LayoutBuilder(
      builder: (context, constraints) {
        return _pieceOrKiloProductChoose(constraints: constraints);
      },
    );
  }

  Widget _pieceOrKiloProductChoose({required BoxConstraints constraints}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(4),
            onTap: () {
              if(!pieceProduct) {
                setState(() {
                  pieceProduct = true;
                  kiloLitreProduct = false;
                  widget.kiloLitreProductState(kiloLitreProduct);
                  widget.pieceProductState(pieceProduct);
                });
              }
            },
            child: _switch(state: pieceProduct, label: 'Piece product'),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(4),
            onTap: () {
              if(!kiloLitreProduct) {
                setState(() {
                  kiloLitreProduct = true;
                  pieceProduct = false;
                  widget.kiloLitreProductState(kiloLitreProduct);
                  widget.pieceProductState(pieceProduct);
                });
              }
            },
            child: _switch(state: kiloLitreProduct, label: 'Kilo/litre product'),
          ),
        ],
      ),
    );
  }

  Widget _switch({
    required bool state,
    required String label
  }) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: ClipOval(
            child:  Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                color: !state ? Colors.transparent : Colors.black,
                border: Border.all(color: !state ? AppColors().appActionColor(context: context) : Colors.transparent),
                borderRadius: BorderRadius.circular(800000)
              ),
            )
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(label, style: AppTextStyle().smallSize(context: context),),
        ),
      ],
    );
  }

}