import 'dart:typed_data';

import 'package:easypos/common/widgets/image_show_upload_widget.dart';
import 'package:easypos/common/widgets/name_textfield.dart';
import 'package:easypos/core/failure.dart';
import 'package:easypos/data/datasources/firebase/firebase_auth_repo_impl.dart';
import 'package:easypos/data/datasources/firebase/firebase_store_repo_impl.dart';
import 'package:easypos/models/store_model.dart';
import 'package:easypos/utils/app_colors.dart';
import 'package:easypos/utils/app_sizes.dart';
import 'package:easypos/utils/app_textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateStore extends StatefulWidget {
  final VoidCallback onCreateDone;
  const CreateStore({super.key, required this.onCreateDone});

  @override
  State<CreateStore> createState() => _CreateStoreState();
}

class _CreateStoreState extends State<CreateStore> {
  TextEditingController controller = TextEditingController();
  Uint8List? storeImage;

  //formKeys::
  final _storeformKey = GlobalKey<FormState>();

  //func

  Future<void> createStoreCall() async{
    String userId = FirebaseAuthRepoImpl().currentUser!.uid;
    String storeId = RemoteStoreDataSourceImpl().getStoreIdForNewStore();
    final StoreModel newStore = StoreModel(
      createdAt: DateTime.now().toUtc().toString(), 
      storeId: storeId, 
      parentStoreId: '', 
      storeName: controller.text.trim(), 
      storeImageId: storeId, 
      storeAddress: '', 
      aboutStore: '', 
      storeType: '', 
      totalProductCategories: 0
    );

    await RemoteStoreDataSourceImpl().createNewOrUpdateStore(store: newStore)
      .then((dataResult) => 
        dataResult.fold(
          (dataFailure) {
            if(dataFailure.failure == Failure.socketFailure) {
              Fluttertoast.showToast(msg: "You are offline. Check your internet connection");
            }
            if(dataFailure.failure == Failure.severFailure) {
              Fluttertoast.showToast(msg: "Failure: Server failed.");
            } else {
              Fluttertoast.showToast(msg: dataFailure.message);
            }
          } ,
          (success) {
            Fluttertoast.showToast(msg: "Congrats! Your store is build and ready.");
            widget.onCreateDone();
          }
        )
      );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("New Store", style: AppTextStyle().boldXtraBigSize(context: context),),
                Column(
                  //mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 220,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: storeImage == null ?
                            Container(
                              height: 140,
                              width: 140,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(5000),
                              ),
                              child: const Icon(Icons.image, color: Colors.grey, size: 100,),
                            )
                            :
                            Image.memory(
                              storeImage!,
                              fit: BoxFit.cover,
                              width: 140,
                              height: 140,
                            )
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Wrap(
                              runAlignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                 ImageShowUploadWidget(
                                  heroTagForImage: 'dd', 
                                  image: storeImage, 
                                  onUpload:(image) {
                                    storeImage = image;
                                  },
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 75,
                      child: Form(
                        key: _storeformKey,
                        child: NameTextfield(
                          maxLines: 1, 
                          onChanged:(text) {
                            if(mounted) {
                              _storeformKey.currentState!.validate();
                            }
                          },
                          controller: controller, 
                          hintText: 'Give a name to your store', 
                          labelText: "Store name", 
                          validationCheck:(text) {
                            
                            if(text.isEmpty) {
                              return "This field can not be empty";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: AppSizes().verticalSpace2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors().grey(),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: InkWell(
                              onTap: (){
                                Navigator.of(context).pop();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    'Cancel',
                                    style: AppTextStyle().boldBigSize(context: context),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: AppSizes().horizontalSpace2,),
                        Expanded(
                          child: InkWell(
                            onTap: () async{
                              await createStoreCall();
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: AppColors().appActionColor(context: context),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    'Create',
                                    style: AppTextStyle().boldBigSize(context: context),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}