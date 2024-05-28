import 'package:easypos/pages/store/controller/store_data_controller.dart';
import 'package:easypos/pages/store/screens/billing/controller/billing_data_controller.dart';
import 'package:easypos/pages/store/screens/billing/screen/item_select_billing/item_select_billing_layout.dart';
import 'package:easypos/pages/store/screens/billing/widgets/billing_queue_widget.dart';
import 'package:easypos/utils/app_sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class BillingMain extends StatefulWidget {
  const BillingMain({super.key});

  @override
  State<BillingMain> createState() => _BillingMainState();
}

class _BillingMainState extends State<BillingMain> {
    
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Material(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap:() {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context)=> ItemSelectBillingLayout(
                            bill: context.read<BillingDataController>().newBill(
                              storeId: context.read<StoreDataController>().currentStore!.storeId))));
                    },
                    child: Container(
                      height: 150,
                      width: constraints.maxWidth,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [ Colors.teal.shade800, Colors.teal.shade800, Colors.teal.shade700, Colors.teal,]),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(color: Color(0x1F000000), blurRadius: 5)
                        ]
                      ),
                      child: Center(
                        child: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return  LinearGradient(
                              colors: [Colors.white, Colors.orange.shade500, Colors.orange.shade700],
                            ).createShader(bounds);
                          },
                          blendMode: BlendMode.srcATop,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.add, color: Colors.white, size: 30,),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('New bill', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: AppSizes().extraBig),),
                                    Text(' (Instore)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: AppSizes().small)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.black.withOpacity(.1)
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 60,
                            width: constraints.maxWidth,
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("In Store Queue", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                            ),
                          ),
                          const Flexible(child: Padding(
                            padding: EdgeInsets.all(4.0),
                            child: BillingQueueWidget(),
                          ))
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}