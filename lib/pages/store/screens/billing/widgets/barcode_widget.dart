import 'package:easypos/common/widgets/name_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BarcodeWidget extends StatefulWidget {
  const BarcodeWidget({super.key});

  @override
  State<BarcodeWidget> createState() => _BarcodeWidgetState();
}

class _BarcodeWidgetState extends State<BarcodeWidget> {
  TextEditingController _controller = TextEditingController();
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
                hintText: 'Type or scan barcode', 
                labelText: '', 
                validationCheck:(text) {
                  
                },),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Container(
                height: 60,
                width: constraints.maxWidth * .3,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(color: Color(0x1F000000), blurRadius: 5)
                  ]
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: Text('Scan')),
                )
              ),
            ),
          ],
        );
      },
    );
  }
}