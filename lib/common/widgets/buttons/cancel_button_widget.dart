import 'package:easypos/utils/app_textstyles.dart';
import 'package:flutter/material.dart';

class CancelButtonWidget extends StatelessWidget {
  final VoidCallback onCancel;
  const CancelButtonWidget({super.key, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        //border: Border.all(color: Colors.grey.shade300),
        // boxShadow: const[
        //   BoxShadow(color: Color(0x1F000000), blurRadius: 8)
        // ]
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          onCancel();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8),
          child: Text(
            'Cancel',
            style: AppTextStyle().greyBoldNormalSize(context: context),
          ),
        ),
      ),
    );
  }
}

