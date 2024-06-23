import 'package:easypos/common/widgets/text_widgets.dart';
import 'package:flutter/material.dart';

class ButtonCollection {
  Widget sizedButton({required double buttonHeight, required double buttonWidth, required String buttonText, required bool wantShadow, required Color buttonColor, required Color textColor, required VoidCallback onButtonTap}) {
    return Container(
      height: buttonHeight,
      width: buttonWidth,
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: !wantShadow ? null : const[
          BoxShadow(color: Color(0x1F000000), blurRadius: 8)
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            onButtonTap();
          },
          child: Center(child: TextWidgets().buttonText(buttonText: buttonText, textColor: textColor)),
        ),
      ),
    );
  }


  Widget sizedSaveButton({required double buttonHeight, required double buttonWidth, required bool wantShadow, required Color buttonColor, required Color textColor, required VoidCallback onButtonTap}) {
    return Container(
      height: buttonHeight,
      width: buttonWidth,
      decoration: BoxDecoration(
        color: buttonColor,
        border: Border.all(color: Colors.green.shade100),
        borderRadius: BorderRadius.circular(8),
        boxShadow: !wantShadow ? null : const[
          BoxShadow(color: Color(0x1F000000), blurRadius: 8)
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            onButtonTap();
          },
          child: Center(child: TextWidgets().buttonTextHigh(buttonText: 'Save', textColor: textColor)),
        ),
      ),
    );
  }

  Widget editButton({
    required double borderRadius, 
    required String editText, 
    required bool wantShadow, 
    required Color buttonColor, 
    required Color textColor, 
    required Color iconColor,
    required VoidCallback onButtonTap}) {
    return Container(
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: !wantShadow ? null : const[
          BoxShadow(color: Color(0x1F000000), blurRadius: 8)
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            onButtonTap();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14),
            child: Row(
              children: [
                Icon(Icons.edit, size: 20, color: iconColor,),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: TextWidgets().buttonText(buttonText: editText, textColor: textColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}