import 'package:easypos/utils/app_textstyles.dart';
import 'package:flutter/material.dart';

class DescriptionTextfield extends StatelessWidget {
  final TextEditingController controller;
  final Function (String text) onChanged;
  final String hintText;
  final String labelText;
  final int? maxLines;
  DescriptionTextfield({
    required this.maxLines,
    required this.onChanged,
    required this.controller,
    required this.hintText,
    required this.labelText,
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
          floatingLabelBehavior: FloatingLabelBehavior.always,
          alignLabelWithHint: false,
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          hintText: hintText,
          label: Text(labelText),
          labelStyle: AppTextStyle().bigSize(context: context),
          hintStyle: const TextStyle(color: Colors.grey),
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black38,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.green,
            ),
          ),
        ),
        onChanged: (value) {
          onChanged(value);
          
        },
      ),
    );
  }
}