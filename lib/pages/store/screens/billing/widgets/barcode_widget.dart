import 'package:easypos/common/widgets/name_textfield.dart';
import 'package:easypos/utils/app_textstyles.dart';
import 'package:easypos/utils/dekhao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BarcodeWidget extends StatefulWidget {
  final Function (String barcodeText) onGettingBarcode;
  const BarcodeWidget({super.key, required this.onGettingBarcode});

  @override
  State<BarcodeWidget> createState() => _BarcodeWidgetState();
}

class _BarcodeWidgetState extends State<BarcodeWidget> {
  final TextEditingController _controller = TextEditingController();

  //functions::
  Future<void>scanCode() async{
    String barcodeText = '';
    try {
      await FlutterBarcodeScanner
      .scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.BARCODE)
        .then((scannedText) {
          setState(() {
            barcodeText = scannedText;
            _controller.text = barcodeText;
            dekhao(barcodeText);
            widget.onGettingBarcode(barcodeText);
          });
        });
    } on PlatformException{
      Fluttertoast.showToast(msg: 'Platform denied! Try again.');
    }
  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [
            SizedBox(
              height: 60,
              width: constraints.maxWidth * .65,
              child: NameTextfield(
                maxLines: 1, 
                onChanged:(text) {
                  
                }, 
                controller: _controller, 
                hintText: "Type product's barcode", 
                labelText: 'Barcode text', 
                validationCheck:(text) {
                  
                },),
            ),

            Flexible(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(color: Color(0x1F000000), blurRadius: 5)
                        ]
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () async{
                            await scanCode();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                            child: Center(child: Icon(Icons.search, color: Colors.black,)),
                          ),
                        ),
                      )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(color: Color(0x1F000000), blurRadius: 5)
                        ]
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () async{
                            await scanCode();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                            child: Center(child: Icon(Icons.qr_code_scanner_sharp, color: Colors.black,)),
                          ),
                        ),
                      )
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

}