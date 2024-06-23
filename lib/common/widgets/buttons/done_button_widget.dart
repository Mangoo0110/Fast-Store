import 'package:easypos/utils/app_textstyles.dart';
import 'package:flutter/material.dart';

class DoneButtonWidget extends StatelessWidget {
  final VoidCallback onDone;
  const DoneButtonWidget({super.key, required this.onDone});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green.shade100),
            boxShadow: const[
              BoxShadow(color: Color(0x1F000000), blurRadius: 8)
            ]
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                onDone();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8),
                child: Row(
                  children: [
                    const Icon(Icons.done_all, color: Colors.green,),
                    
                      Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: Text('Done', style: AppTextStyle().boldNormalSize(context: context),)
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}