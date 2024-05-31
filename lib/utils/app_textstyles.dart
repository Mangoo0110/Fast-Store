import 'package:easypos/utils/app_colors.dart';
import 'package:easypos/utils/app_sizes.dart';
import 'package:flutter/material.dart';

class AppTextStyle {
  TextStyle boldNormalSize({
    required BuildContext context
  }) {
    return TextStyle(color: AppColors().appTextColor(context: context), overflow: TextOverflow.ellipsis, fontSize: AppSizes().normalText, fontWeight: FontWeight.bold);
  }
  TextStyle bigSize({
    required BuildContext context
  }) {
    return TextStyle(color: AppColors().appTextColor(context: context), overflow: TextOverflow.ellipsis, fontSize: AppSizes().big, fontWeight: FontWeight.normal);
  }

  TextStyle actionBoldNormalSize({
    required BuildContext context
  }) {
    return TextStyle(color: AppColors().appActionColor(context: context), overflow: TextOverflow.ellipsis, fontSize: AppSizes().normalText, fontWeight: FontWeight.bold);
  }

  TextStyle buttonTextStyleNormal({
    required BuildContext context
  }) {
    return TextStyle(color: Colors.white, overflow: TextOverflow.ellipsis, fontSize: AppSizes().normalText, fontWeight: FontWeight.bold);
  }

  TextStyle appBarTextStyle({
    required BuildContext context
  }) {
    return TextStyle(color: Colors.white, overflow: TextOverflow.ellipsis, fontSize: AppSizes().big, fontWeight: FontWeight.bold);
  }

  TextStyle actionBoldSmallSize({
    required BuildContext context
  }) {
    return TextStyle(color: AppColors().appActionColor(context: context), overflow: TextOverflow.ellipsis, fontSize: AppSizes().small, fontWeight: FontWeight.bold);
  }

  TextStyle boldBigSize({
    required BuildContext context
  }) {
    return TextStyle(color: AppColors().appTextColor(context: context), overflow: TextOverflow.ellipsis, fontSize: AppSizes().big, fontWeight: FontWeight.bold);
  }

  TextStyle boldXtraBigSize({
    required BuildContext context
  }) {
    return TextStyle(color: AppColors().appTextColor(context: context), overflow: TextOverflow.ellipsis, fontSize: AppSizes().extraBig, fontWeight: FontWeight.bold);
  }

  TextStyle boldHeader({
    required BuildContext context
  }) {
    return TextStyle(color: AppColors().appTextColor(context: context), overflow: TextOverflow.ellipsis, fontSize: AppSizes().header, fontWeight: FontWeight.bold);
  }

  TextStyle normalSize({
    required BuildContext context
  }) {
    return TextStyle(color: AppColors().appTextColor(context: context), overflow: TextOverflow.ellipsis, fontSize: AppSizes().normalText);
  }
  TextStyle normalSizeGrey({
    required BuildContext context
  }) {
    return TextStyle(color: AppColors().appTextColorGrey(context: context), overflow: TextOverflow.ellipsis, fontSize: AppSizes().normalText);
  }

  TextStyle boldSmallSize({
    required BuildContext context
  }) {
    return TextStyle(color: AppColors().appTextColor(context: context), overflow: TextOverflow.ellipsis, fontSize: AppSizes().small, fontWeight: FontWeight.bold);
  }

  TextStyle greyBoldNormalSize({
    required BuildContext context
  }) {
    return TextStyle(color: AppColors().appTextColorGrey(context: context), overflow: TextOverflow.ellipsis, fontSize: AppSizes().normalText, fontWeight: FontWeight.bold);
  }

  TextStyle greyBoldItalicNormalSize({
    required BuildContext context
  }) {
    return TextStyle(color: AppColors().appTextColorGrey(context: context), overflow: TextOverflow.ellipsis, fontSize: AppSizes().normalText, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic);
  }

  TextStyle greyBoldSmallSize({
    required BuildContext context
  }) {
    return TextStyle(color: AppColors().appTextColorGrey(context: context), overflow: TextOverflow.ellipsis, fontSize: AppSizes().small, fontWeight: FontWeight.bold);
  }
  
  TextStyle smallSize({
    required BuildContext context
  }) {
    return TextStyle(color: AppColors().appTextColor(context: context), overflow: TextOverflow.ellipsis, fontSize: AppSizes().small,);
  }

  TextStyle blackExtraSmallSize({
    required BuildContext context
  }) {
    return TextStyle(color: Colors.black, fontSize: AppSizes().extraSmall, overflow: TextOverflow.ellipsis,);
  }

  TextStyle greySmallSize({
    required BuildContext context
  }) {
    return TextStyle(color: AppColors().appTextColorGrey(context: context), overflow: TextOverflow.ellipsis, fontSize: AppSizes().small,);
  }
}

