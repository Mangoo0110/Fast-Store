import 'package:easypos/utils/app_sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InvoiceSectionWidget extends StatefulWidget {
  final int initialIndex;
  final List<String> sectionNameList;
  final Function (int selectedIndex) onTap;
  const InvoiceSectionWidget({super.key, required this.sectionNameList, required this.onTap, required this.initialIndex});

  @override
  State<InvoiceSectionWidget> createState() => _InvoiceSectionWidgetState();
}

class _InvoiceSectionWidgetState extends State<InvoiceSectionWidget> {

  int selectedSectionIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    selectedSectionIndex = widget.initialIndex;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.sectionNameList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(800000),
                  boxShadow: const [
                    BoxShadow(color: Color(0x1F000000), blurRadius: 5)
                  ]
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8000000),
                    onTap: () {
                      
                      setState(() {
                        widget.onTap(index);
                        selectedSectionIndex = index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12),
                      child: Center(
                        child: Text(
                          widget.sectionNameList[index],
                          style: TextStyle(color: Colors.black, fontSize: AppSizes().small),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}