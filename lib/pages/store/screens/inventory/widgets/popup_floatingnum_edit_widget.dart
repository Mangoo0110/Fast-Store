import 'package:easypos/common/data/app_regexp.dart';
import 'package:easypos/common/widgets/textfields/quantity_textfield.dart';
import 'package:easypos/utils/app_colors.dart';
import 'package:easypos/utils/app_textstyles.dart';
import 'package:easypos/utils/dekhao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PopupFloatingNumEditWidget extends StatefulWidget {
  final String headerName;
  final String initialText;
  final Function(double num) onDone;
  const PopupFloatingNumEditWidget({super.key, required this.initialText, required this.onDone, required this.headerName});

  @override
  State<PopupFloatingNumEditWidget> createState() => _PopupFloatingNumEditWidgetState();
}

class _PopupFloatingNumEditWidgetState extends State<PopupFloatingNumEditWidget> {

  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    _controller.text = widget.initialText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CupertinoPageScaffold(
          child: Column(
            children: [
              Text(widget.headerName, style: AppTextStyle().boldNormalSize(context: context),),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  height: 65,
                  width: constraints.maxWidth,
                  child: Form(
                    key: _formKey,
                    child: QuantityTextField(
                      maxLines: 1, 
                      onChanged: (value){
                        dekhao("QuantityTextField $value");
                        if(mounted && _formKey.currentState != null) {
                          _formKey.currentState!.validate();
                        }
                        
                      }, 
                      controller: _controller, 
                      hintText: 'Product quantity', 
                      labelText: '(e.g, .145, 20, 23.4, 1003)', 
                      validationCheck: (value){
                        if(value == '') return 'This field cannot be empty!';
                        if(!double.tryParse(value)!.isNaN) {
                          return "Enter a valid number. (e.g, .145, 20, 23.4, 1003)";
                        }
                      }, 
                      numRegExp: moneyRegExp(),
                      onlyInteger: false
                    ),
                  ),
                ),
              ),
              FloatingActionButton(
                onPressed: (){
                  if(mounted && _formKey.currentState!.validate()) {
                    widget.onDone(double.tryParse(_controller.text) ?? 0);
                    Navigator.of(context).pop();
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors().appActionColor(context: context),
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                    child: Text(
                      'Done',
                      style: AppTextStyle().boldNormalSize(context: context),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  
  }

}