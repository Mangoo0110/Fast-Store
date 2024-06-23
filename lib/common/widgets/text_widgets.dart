import 'package:flutter/material.dart';

class TextWidgets {

  Widget popupHeader({required String headerText, required Color textColor}) {
    return Text(headerText,  style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis), maxLines: 1);
  }

  Widget buttonText({required String buttonText, required Color textColor}) {
    return Text(buttonText,  style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis), maxLines: 1,);
  }

  Widget normalText({required String text, required Color textColor}) {
    return Text(text,  style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.normal, overflow: TextOverflow.ellipsis), maxLines: 1,);
  }

  Widget buttonTextHigh({required String buttonText, required Color textColor}) {
    return Text(buttonText,  style: TextStyle(color: textColor, fontSize: 17, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis), maxLines: 1,);
  }

  Widget titleText({required String titleText, required Color textColor}) {
    return Text(titleText,  style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.w500, overflow: TextOverflow.ellipsis), maxLines: 2,);
  }

  Widget subtitleText({required String titleText, required Color textColor}) {
    return Text(titleText,  style: TextStyle(color: textColor, fontSize: 14, overflow: TextOverflow.ellipsis), maxLines: 1,);
  }

  Widget highLightText({required String text, required Color textColor}) {
    return Text(text,  style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis), maxLines: 2);
  }
}