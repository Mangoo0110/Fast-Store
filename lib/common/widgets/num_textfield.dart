import 'package:easypos/utils/app_textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumTextfield extends StatefulWidget {
  final TextEditingController controller;
  final Function (String text) onChanged;
  final Function (String text) validationCheck;
  final VoidCallback onTap;
  final String hintText;
  final String labelText;
  final int? maxLines;
  final bool onlyInteger;
  final RegExp numRegExp;
  NumTextfield({
    required this.maxLines,
    required this.onChanged,
    required this.controller,
    required this.hintText,
    required this.labelText,
    required this.validationCheck,
    required this.onlyInteger,
    required this.numRegExp,
    super.key, required this.onTap
    });

  @override
  State<NumTextfield> createState() => _NumTextfieldState();
}

class _NumTextfieldState extends State<NumTextfield> {
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => TextFormField(
        onTap: () {
          _focusNode.requestFocus();

          setState(() {
            
          });
        },
        onTapOutside: (event){
          _focusNode.unfocus();
          setState(() {
            
          });
        },
        focusNode: _focusNode,
        maxLines: widget.maxLines,
        controller: widget.controller,
        showCursor: _focusNode.hasFocus,
        style: AppTextStyle().normalSize(context: context),
        decoration: InputDecoration(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          hintText: widget.hintText,
          label: Text(widget.labelText),
          labelStyle: AppTextStyle().normalSize(context: context),
          hintStyle: const TextStyle(color: Colors.grey),
          border: const UnderlineInputBorder(),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.green, width: 2),
          )
        ),
        keyboardType: TextInputType.numberWithOptions(decimal: !widget.onlyInteger),
        inputFormatters: [
          FilteringTextInputFormatter.allow(widget.numRegExp),
        ],
        onChanged: (value) {
          widget.onChanged(value);
        },
        validator: (value) {
          return widget.validationCheck(value!);
        },
      ),
    );
  }

}