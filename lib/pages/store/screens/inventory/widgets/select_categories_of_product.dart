import 'package:easypos/models/category_list_model.dart';
import 'package:easypos/pages/store/controller/store_data_controller.dart';
import 'package:easypos/utils/app_sizes.dart';
import 'package:easypos/utils/app_textstyles.dart';
import 'package:easypos/utils/dekhao.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectShowCategoriesWidget extends StatefulWidget {
  final Set<String> selectedCategorySet;
  final void Function (Set<String> newSelectedCategorySet) onSelect;
  const SelectShowCategoriesWidget({super.key, required this.selectedCategorySet, required this.onSelect});

  @override
  State<SelectShowCategoriesWidget> createState() => _SelectShowCategoriesWidgetState();
}

class _SelectShowCategoriesWidgetState extends State<SelectShowCategoriesWidget> {

  //sets ::
  Set<String> selectedCategorySet = {};

  // lists ::
  List<String> storeCategoryList = [];

  //functions 

  _populateStoreCategoryList() {
    final Map<String, String> categoryMapOfStore = context.read<StoreDataController>().categoryMapImageIdOfStore;
    categoryMapOfStore.forEach((key, value) { 
      if(key != 'All products') {
        storeCategoryList.add(key);
        dekhao(key);
      }
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    selectedCategorySet = widget.selectedCategorySet;
    _populateStoreCategoryList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _selectCategory(constraints: constraints), 
              Padding(
                padding: const EdgeInsets.all(6),
                child: _selectedCategories(constraints: constraints),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _selectedCategories({required BoxConstraints constraints}){
    return Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.start,
      spacing: 2,
      runSpacing: 4,
      children: selectedCategorySet.map((category) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(500000),
            color: Colors.black,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedCategorySet.remove(category);
                  widget.onSelect(selectedCategorySet);
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: Colors.white, 
                        fontSize: (category.length * AppSizes().normalText > constraints.maxWidth) ? AppSizes().small : AppSizes().normalText,
                        overflow: TextOverflow.ellipsis
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(Icons.cancel, color: Colors.white,),
                  )
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _selectCategory({required BoxConstraints constraints}){
    return DropdownButton(
      borderRadius: BorderRadius.circular(8),
      enableFeedback: true,
      underline: Container(),
      //isExpanded: true,
      padding: const EdgeInsets.all(8),
      hint: Text('Categories', style: AppTextStyle().greyBoldNormalSize(context: context),),
      onChanged: (selectedCategory) {
        if(selectedCategory != null) {
          setState(() {
            selectedCategorySet.add(selectedCategory);
          });
        }
      },
      items: storeCategoryList.map((category) {
        return DropdownMenuItem(
          value: category, 
          child: Container(
            padding: const EdgeInsets.all(4),
            child: Text(category, style: AppTextStyle().normalSize(context: context),),
          ), 
        );
      }
    ).toList());
  
  }
}