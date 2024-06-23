import 'dart:typed_data';

import 'package:easypos/common/widgets/textfields/name_textfield.dart';
import 'package:easypos/data/datasources/firebase/firebase_category_repo_impl.dart';
import 'package:easypos/pages/store/controller/store_data_controller.dart';
import 'package:easypos/common/widgets/image_related/image_show_upload_widget.dart';
import 'package:easypos/utils/app_textstyles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class CreateCategory extends StatefulWidget {
  final VoidCallback onCreateDone;
  const CreateCategory({super.key, required this.onCreateDone});

  @override
  State<CreateCategory> createState() => _CreateCategoryState();
}

class _CreateCategoryState extends State<CreateCategory> {
  TextEditingController controller = TextEditingController();
  Uint8List? categoryImage;

  //formKeys::
  final _categoryNameformKey = GlobalKey<FormState>();

  //maps ::
  Set<String> existingCategorySet = {};

  // functions

  Future<void> _createCategory() async{
    if(_categoryNameformKey.currentState!.validate() && mounted) {
      await FirebaseCategoryRepoImpl().createNewCategory(categoryName: controller.text.trim(), categoryImage: categoryImage, storeId: context.read<StoreDataController>().currentStore!.storeId).then(
        (result) => result.fold(
          (dataFailure) {
            Fluttertoast.showToast(msg: "Failed! \n ${dataFailure.message}");
          } ,
          (success) {
            Fluttertoast.showToast(msg: success.message);
            if(mounted){
              Navigator.pop(context);
            }
          }
        )
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Category", style: AppTextStyle().boldXtraBigSize(context: context),),
        actions: [
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Cancel', style: AppTextStyle().greyBoldNormalSize(context: context),),
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () async{
              await _createCategory();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Create', style: AppTextStyle().actionBoldNormalSize(context: context),),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ImageShowUploadWidget(
                    heroTagForImage: 'kk',
                    image: null, 
                    onUpload:(image) {
                      
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              SizedBox(
                height: 75,
                child: Form(
                  key: _categoryNameformKey,
                  child: NameTextfield(
                    maxLines: 1, 
                    onChanged:(text) {
                      if(mounted) {
                        _categoryNameformKey.currentState!.validate();
                      }
                    },
                    controller: controller, 
                    hintText: 'Category name should be unique', 
                    labelText: "Category name", 
                    validationCheck:(text) {
                      if(existingCategorySet.contains(text)){
                        return "Already exist";
                      }
                      if(text.isEmpty) {
                        return "This field can not be empty";
                      }
                      return null;
                    },
                  ),
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  
  }
}