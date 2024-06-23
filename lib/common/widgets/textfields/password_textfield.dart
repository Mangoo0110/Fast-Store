import 'package:easypos/utils/app_textstyles.dart';
import 'package:flutter/material.dart';

class PasswordTextfield extends StatefulWidget {
  final TextEditingController controller;
  final Function (String text) onChanged;
  final Function (String text) validationCheck;
  final String hintText;
  final String labelText;
  final int maxLines;
  const PasswordTextfield({
    required this.maxLines,
    required this.onChanged,
    required this.controller,
    required this.hintText,
    required this.labelText,
    required this.validationCheck,
    super.key
    });

  @override
  State<PasswordTextfield> createState() => _PasswordTextfieldState();
}

class _PasswordTextfieldState extends State<PasswordTextfield> {
  bool obscureState = true;
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (event){
          _focusNode.unfocus();
      },
      focusNode: _focusNode,
      maxLines: widget.maxLines,
      controller: widget.controller,
      obscureText: obscureState,
      style: AppTextStyle().normalSize(context: context),
      decoration: InputDecoration(
        suffixIcon: InkWell(
          onTap: () {
            setState(() {
              obscureState = !obscureState;
            });
          },
          child: obscureState ?
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.visibility),
            )
            :
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.visibility_off),
            )
        ),
        //alignLabelWithHint: true,
        hintText: widget.hintText,
        label: Text(widget.labelText),
        labelStyle: AppTextStyle().normalSize(context: context),
        hintStyle:  AppTextStyle().boldNormalSize(context: context),
        border: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black38,
            ),
        ),
      ),
      onChanged: (value) {
        widget.onChanged(value);
      },
      validator: (value) {
        if(value ==null || value.isEmpty) {
          return "Enter your ${widget.hintText.toLowerCase()} correctly!";
        }
        return null;
      },
    );
  }
}