import 'package:easypos/utils/app_textstyles.dart';
import 'package:flutter/material.dart';

class EmailTextfield extends StatelessWidget {
  final TextEditingController controller;
  final Function (String text) onChanged;
  final Function (String text) validationCheck;
  final String hintText;
  final String labelText;
  final int? maxLines;
  EmailTextfield({
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
        onTap: () {
          _focusNode.requestFocus();
        },
        onTapOutside: (event){
          _focusNode.unfocus();
        },
        focusNode: _focusNode,
        maxLines: maxLines,
        controller: controller,
        style: AppTextStyle().normalSize(context: context),
        decoration: InputDecoration(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          hintText: hintText,
          label: Text(labelText),
          labelStyle: AppTextStyle().normalSize(context: context),
          hintStyle: const TextStyle(color: Colors.grey),
          border: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black38,
              ),
          ),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.green,
                width: 2
              ),
          ),
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