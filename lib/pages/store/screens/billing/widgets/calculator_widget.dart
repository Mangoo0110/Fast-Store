import 'dart:math';

import 'package:easypos/common/widgets/textfields/calculator_textfield.dart';
import 'package:easypos/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CalculatorWidget extends StatefulWidget {
  const CalculatorWidget({super.key});

  @override
  State<CalculatorWidget> createState() => _CalculatorWidgetState();
}

class _CalculatorWidgetState extends State<CalculatorWidget> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          //crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 60,
              width: constraints.maxWidth ,
              child: CalculatorTextfield(
                maxLines: 1, 
                onChanged:(text) {
                  
                }, 
                controller: _controller, 
                hintText: '', 
                labelText: '', 
                validationCheck:(text) {
                  
                },),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 14.0),
              child: _calculator(),
            )
          ],
        );
      },
    );
  }

  Widget _calculator(){
    List<String> num1to9 = [];
    for(int ind = 1; ind <=9; ind ++) {
      num1to9.add(ind.toString());
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        double buttonHeight = 60;
        double buttonWidth = min(200, constraints.maxWidth / 4);
        return Row(
          children: [
            SizedBox(
              width: min(200, constraints.maxWidth / 4) * 3,
              child: Column(
                children: [
                  Wrap(
                    runSpacing: 1,
                    spacing: 1,
                    children: num1to9.map((number) {
                      return Container(
                        height: buttonHeight,
                        width: buttonWidth - 5,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors().grey()),
                          boxShadow: const [
                            BoxShadow(color: Color(0x1F000000), blurRadius: 5)
                          ]
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _controller.text = '${_controller.text}$number';
                              });
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Center(
                              child: Text(
                                number, style: TextStyle(color: Colors.black, fontSize: buttonHeight / 2 - 10, overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList()
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Container(
                          height: buttonHeight ,
                          width: buttonWidth * 1.5 - 5,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors().grey())
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _controller.text = '${_controller.text}0';
                                });
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Center(
                                child: Text(
                                  '0', style: TextStyle(color: Colors.black, fontSize: buttonHeight / 2 - 10, overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Container(
                            height: buttonHeight ,
                            //width: buttonWidth * 1.5 - 5,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors().grey())
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _controller.text = '${_controller.text}.';
                                  });
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: Center(
                                  child: Text(
                                    '.', style: TextStyle(color: Colors.black, fontSize: buttonHeight / 2 - 10, overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Container(
                        height: buttonHeight * 2 - 2,
                        width: buttonWidth - 5,
                        decoration: BoxDecoration(
                          color: Colors.orange.shade600,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Center(
                              child: Text(
                                'X', style: TextStyle(color: Colors.black, fontSize: buttonHeight / 2 - 10, overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                      
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Container(
                        height: buttonHeight * 2 - 2,
                        width: buttonWidth,
                        decoration: BoxDecoration(
                          color: AppColors().appActionColor(context: context),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Center(
                              child: Text(
                                '+', style: TextStyle(color: Colors.black, fontSize: buttonHeight / 2 , overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }
}