import 'package:easypos/utils/app_colors.dart';
import 'package:easypos/utils/app_textstyles.dart';
import 'package:flutter/material.dart';

class CustomerDetailsWidget extends StatefulWidget {
  final String customerName;
  final String customerContactNo;
  final Function (String customerName, String customerContactNo) onEntry;
  const CustomerDetailsWidget({super.key, required this.onEntry, required this.customerName, required this.customerContactNo});

  @override
  State<CustomerDetailsWidget> createState() => _CustomerDetailsWidgetState();
}

class _CustomerDetailsWidgetState extends State<CustomerDetailsWidget> {
  String customerName = '';
  String customerContactNo = '';

  @override
  void initState() {
    // TODO: implement initState
    customerName = widget.customerName;
    customerContactNo = widget.customerContactNo;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors().appActionColor(context: context).withAlpha(50),
        border: Border.all(
          color: Colors.black
        ),
        borderRadius: BorderRadius.circular(8000000),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8000000),
          onTap: () {
            
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 6),
            child: Row(
              children: [
                const Icon(Icons.person, color: Colors.black,),
                Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: Text(customerName.isNotEmpty ? customerName : customerContactNo.isNotEmpty ? customerContactNo : '+ Add customer', style: AppTextStyle().boldSmallSize(context: context),),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}