import 'package:easypos/utils/app_sizes.dart';
import 'package:flutter/material.dart';

class Spaces {
  Widget verticalSpace1() {
    return SizedBox(height: AppSizes().verticalSpace1);
  }

  Widget verticalSpace2() {
    return SizedBox(height: AppSizes().verticalSpace2);
  }

  Widget horizontalSpace1() {
    return SizedBox(width: AppSizes().horizontalSpace1);
  }

  Widget horizontalSpace2() {
    return SizedBox(width: AppSizes().horizontalSpace2);
  }
}