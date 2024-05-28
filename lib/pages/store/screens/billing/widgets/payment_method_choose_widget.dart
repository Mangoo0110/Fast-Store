import 'package:easypos/utils/app_colors.dart';
import 'package:easypos/utils/app_textstyles.dart';
import 'package:flutter/material.dart';

class PaymentMethodWidget extends StatefulWidget {
  const PaymentMethodWidget({super.key});

  @override
  State<PaymentMethodWidget> createState() => _PaymentMethodWidgetState();
}

class _PaymentMethodWidgetState extends State<PaymentMethodWidget> {
  List<String> paymentMethodsNameList = [
    'Cash',
    'Card',
    'Mob. Banking',
  ];
  String selectedMethodName = 'Cash';

  @override
  void initState() {
    // TODO: implement initState
    selectedMethodName = paymentMethodsNameList[0];
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    // return LayoutBuilder(
    //   builder: (context, constraints) {
    //     return Row(
    //       mainAxisAlignment: MainAxisAlignment.end,
    //       children: paymentMethodsNameList.map((methodName) {
    //         return Padding(
    //           padding: const EdgeInsets.only(left: 2.0),
    //           child: Container(
    //             decoration: BoxDecoration(
    //               color: selectedMethodName == methodName ? AppColors().appActionColor(context: context).withOpacity(.2) : Colors.transparent,
    //               borderRadius: BorderRadius.circular(8),
    //               border: Border.all(color: AppColors().appActionColor(context: context))
    //             ),
    //             child: Material(
    //               color: Colors.transparent,
    //               child: InkWell(
    //                 borderRadius: BorderRadius.circular(8),
    //                 onTap: () {
    //                   setState(() {
    //                     selectedMethodName = methodName;
    //                   });
    //                 },
    //                 child: Padding(
    //                   padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 12),
    //                   child: Center(child: Text(methodName, style: AppTextStyle().boldSmallSize(context: context),)),
    //                 ),
    //               ),
    //             ),
    //           ),
    //         );
    //       }).toList()
    //     );
    //   },
    // );
    return LayoutBuilder(
      builder: (context, constraints) {
        return Material(
          color: Colors.transparent,
          child: DropdownButton(
            borderRadius: BorderRadius.circular(8),
            enableFeedback: true,
            underline: Container(),
            //isExpanded: true,
            padding: const EdgeInsets.all(8),
            hint: Text(selectedMethodName, style: AppTextStyle().actionBoldNormalSize(context: context),),
            onChanged: (methodName) {
              if(methodName != null) {
                setState(() {
                  selectedMethodName = methodName;
                });
              }
            },
            items: paymentMethodsNameList.map((methodName) {
              return DropdownMenuItem(
                value: methodName, 
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: Text(methodName, style: AppTextStyle().normalSize(context: context),),
                ), 
              );
            }
          ).toList()),
        );
      }
    );
  }
}