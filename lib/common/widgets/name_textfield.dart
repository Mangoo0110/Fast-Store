import 'package:easypos/utils/app_textstyles.dart';
import 'package:flutter/material.dart';

class NameTextfield extends StatelessWidget {
  final TextEditingController controller;
  final Function (String text) onChanged;
  final Function (String text) validationCheck;
  final String hintText;
  final String labelText;
  final int? maxLines;
  NameTextfield({
    required this.maxLines,
    required this.onChanged,
    required this.controller,
    required this.hintText,
    required this.labelText,
    required this.validationCheck,
    super.key
    });
  final FocusNode _focusNode = FocusNode(); 

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => TextFormField(
        onTapOutside: (event){
          _focusNode.unfocus();
        },
        focusNode: _focusNode,
        maxLines: maxLines,
        controller: controller,
        style: AppTextStyle().normalSize(context: context),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          alignLabelWithHint: false,
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          hintText: hintText,
          label: Text(labelText),
          labelStyle: AppTextStyle().bigSize(context: context),
          hintStyle: const TextStyle(color: Colors.grey),
          border: const UnderlineInputBorder(),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.green, width: 2),
          )
        ),
        onChanged: (value) {
          onChanged(value);
          
        },
        validator: (value) {
          return validationCheck(value!);
        },
      ),
    );
  }
}