import 'dart:typed_data';

import 'package:easypos/common/widgets/image_show_upload_widget.dart';
import 'package:easypos/common/widgets/name_textfield.dart';
import 'package:easypos/data/datasources/firebase/firebase_image_repo_impl.dart';
import 'package:easypos/data/datasources/firebase/firebase_user_repo_impl.dart';
import 'package:easypos/models/user_model.dart';
import 'package:easypos/pages/user_dashboard/controller/user_data_controller.dart';
import 'package:easypos/utils/app_sizes.dart';
import 'package:easypos/utils/app_textstyles.dart';
import 'package:easypos/utils/dekhao.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class EditUserInfoScreen extends StatefulWidget {
  final String heroTagForImage;
  const EditUserInfoScreen({super.key, required this.heroTagForImage});

  @override
  State<EditUserInfoScreen> createState() => _EditUserInfoScreenState();
}

class _EditUserInfoScreenState extends State<EditUserInfoScreen> {

  TextEditingController userNameInputcontroller = TextEditingController();
  TextEditingController userContactNoInputcontroller =
      TextEditingController();
  Uint8List? userImage;
  bool imageChanged = false;

  UserModel? currentUserInfo;

  //formKeys::
  final _userNameformKey = GlobalKey<FormState>();

  updateUserInfo() async{
    if(currentUserInfo == null) {
      dekhao("currentUserInfo is null");
      return;
    }
    final updatedUserInfo = UserModel(
      userId: currentUserInfo!.userId, 
      userImageId: currentUserInfo!.userImageId, 
      email: currentUserInfo!.email, 
      fullName: userNameInputcontroller.text.trim(), 
      contactNo: userContactNoInputcontroller.text.trim());
    await FirebaseUserRepoImpl().updateCurrentUserInfo(updatedInfo: updatedUserInfo).then((dataResult) {
      dataResult.fold(
        (dataFailure) {
          Fluttertoast.showToast(msg: "Failed! \n ${dataFailure.message}");
        } ,
        (success) async{
          Fluttertoast.showToast(msg: 'User info is updated');
          if(imageChanged && userImage != null) {
            await FirebaseImageRepoImpl().uploadImage(imageBytes: userImage!, imageId: currentUserInfo!.userImageId).then((value) {
              if(mounted) {
                Navigator.pop(context);
              }
            });
          }
        }
      );
    });
  }

  @override
  void initState() {
    currentUserInfo = context.read<UserDataController>().currentUserInfo;
    userImage = context.read<UserDataController>().userImage;
    if(currentUserInfo != null) {
      userNameInputcontroller.text = currentUserInfo!.fullName;
      userContactNoInputcontroller.text = currentUserInfo!.contactNo;
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        appBar: AppBar(
          title: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Edit Info",
                style: AppTextStyle().boldBigSize(context: context),
              )),
          actions: [
            InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Cancel',
                  style: AppTextStyle().greyBoldNormalSize(context: context),
                ),
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () async {
                await updateUserInfo();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Update',
                  style: AppTextStyle().actionBoldNormalSize(context: context),
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ImageShowUploadWidget(
                      heroTagForImage: widget.heroTagForImage,
                      image: userImage,
                      onUpload: (image) {
                        userImage = image;
                        imageChanged = true;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: _userNameEdit(constraints: constraints),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: _userContactNoEdit(constraints: constraints),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }


  Widget _userNameEdit({required BoxConstraints constraints}) {
    return SizedBox(
      height: 75,
      child: Form(
        key: _userNameformKey,
        child: NameTextfield(
          maxLines: 1,
          onChanged: (text) {
            if (mounted) {
              _userNameformKey.currentState!.validate();
            }
          },
          controller: userNameInputcontroller,
          hintText: '(Type your name)',
          labelText: "Name",
          validationCheck: (text) {
            if (text.isEmpty) {
              return "This field can not be empty";
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _userContactNoEdit({required BoxConstraints constraints}) {
    return SizedBox(
      height: 75,
      child: NameTextfield(
        maxLines: 1,
        onChanged: (text) {
          if (mounted) {
            _userNameformKey.currentState!.validate();
          }
        },
        controller: userContactNoInputcontroller,
        hintText: '(Type your contact no)',
        labelText: "Contact no",
        validationCheck: (text) {
          
        },
      ),
    );
  }
}