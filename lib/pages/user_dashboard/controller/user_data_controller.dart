import 'dart:typed_data';

import 'package:easypos/data/datasources/firebase/firebase_image_repo_impl.dart';
import 'package:easypos/data/datasources/firebase/firebase_user_repo_impl.dart';
import 'package:easypos/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserDataController extends ChangeNotifier {
  UserModel? _currentUserInfo;
  Uint8List? _userImage;

  UserModel? get currentUserInfo => _currentUserInfo;

  Uint8List? get userImage => _userImage;

  getUserImage({required String imageId}) async{
    if(userImage != null) return;
    await FirebaseImageRepoImpl().fetchImage(imageId: imageId).then((dataResult) {
      dataResult.fold(
        (dataFailure) {
          Fluttertoast.showToast(msg: "Failed! \n ${dataFailure.message}");
        } ,
        (image) {
          if(image == null) {
            Fluttertoast.showToast(msg: 'Image is not found!');
            
          } 
          _userImage = image;
          notifyListeners();
        }
      );
    });
  }

  getUserInfo() async{
    await FirebaseUserRepoImpl().fetchCurrentUserInfo().then((dataResult) {
      dataResult.fold(
        (dataFailure) {
          Fluttertoast.showToast(msg: "Failed! \n ${dataFailure.message}");
        } ,
        (userInfo) {
          _currentUserInfo = userInfo;
          getUserImage(imageId: userInfo.userImageId);
          notifyListeners();
        }
      );
    });
  }

  Future<void> updateUserInfo({required UserModel updatedUserInfo}) async{
    
  }
  Future<void> updateUserImage({required Uint8List image, required String imageId}) async{
    
  }
  
}