import 'package:easypos/pages/store/screens/inventory/widgets/popup_text_edit_widget.dart';
import 'package:easypos/utils/app_textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BarcodeShowEditWidget extends StatefulWidget {
  final String barcodeText;
  final Function (String newBarcodeText) onBarcodeChange;
  const BarcodeShowEditWidget({super.key, required this.barcodeText, required this.onBarcodeChange});

  @override
  State<BarcodeShowEditWidget> createState() => _BarcodeShowEditWidgetState();
}

class _BarcodeShowEditWidgetState extends State<BarcodeShowEditWidget> {

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    _controller.text = widget.barcodeText.isEmpty ? '(empty)' : widget.barcodeText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            
          },
          child: TextFormField(
            enableInteractiveSelection: false,
            readOnly: true,
            showCursor: false,
            onTap: () {
              showModalBottomSheet(
              context: context, 
              builder:(context) => PopupTextEditWidget(
                headerName: 'Edit Barcode',
                initialText: widget.barcodeText, 
                onDone:(text) {
                  setState(() {
                    widget.onBarcodeChange(text);
                    _controller.text = text;
                    Navigator.pop(context);
                  });
                  
                },));
            },
            focusNode: _focusNode,
            maxLines: 1,
            controller: _controller,
            style: AppTextStyle().normalSize(context: context),
            decoration: InputDecoration(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              hintText: '',
              labelText: 'Barcode (Tap to edit)',
              labelStyle: AppTextStyle().normalSize(context: context),
              hintStyle: const TextStyle(color: Colors.grey),
              border: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: .5,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.green,
                  width: .5
                ),
              ),
            ),
            
            onChanged: (value) {
              
            },
            validator: (value) {
              
            },
          ),
        ),
      ),
    );
  }


}