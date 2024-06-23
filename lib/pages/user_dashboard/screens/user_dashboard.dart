import 'dart:math';

import 'package:easypos/common/widgets/image_related/show_round_image.dart';
import 'package:easypos/common/widgets/spaces.dart';
import 'package:easypos/data/datasources/firebase/firebase_auth_repo_impl.dart';
import 'package:easypos/models/user_model.dart';
import 'package:easypos/pages/user_dashboard/controller/user_data_controller.dart';
import 'package:easypos/pages/user_dashboard/screens/edit_user_info.dart';
import 'package:easypos/pages/user_dashboard/widget/create_store.dart';
import 'package:easypos/pages/user_dashboard/widget/storelist.dart';
import 'package:easypos/utils/app_colors.dart';
import 'package:easypos/utils/app_names.dart';
import 'package:easypos/utils/app_textstyles.dart';
import 'package:easypos/utils/dekhao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {

  UserModel? currentUserInfo;

  @override
  void initState() {
    // TODO: implement initState
    context.read<UserDataController>().getUserInfo();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    currentUserInfo = context.watch<UserDataController>().currentUserInfo;
    return LayoutBuilder(
      builder: (context, constraints) {
        dekhao("constraints.maxHeight ${constraints.maxHeight}");
        double contentMaxScreenWidth = min(constraints.maxWidth, 700);
        return Scaffold(
          appBar: (constraints.maxHeight < 500) ? null : AppBar(
            forceMaterialTransparency: true,
            backgroundColor: AppColors().appBackgroundColor(context: context),
            foregroundColor: AppColors().appBackgroundColor(context: context),
          ),
          backgroundColor: Colors.white,
          body: Padding(
            padding: EdgeInsets.fromLTRB(8, (constraints.maxHeight < 500) ? 10 : constraints.maxHeight * .1, 8, 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(alignment: Alignment.center, child: _appName()),
                Spaces().verticalSpace2(),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //mainAxisSize: MainAxisSize.min,
                    children: [
                      _user(contentMaxScreenWidth: contentMaxScreenWidth),
                      Spaces().verticalSpace2(),
                      Container(
                        height: 1,
                        width: min(500, contentMaxScreenWidth),
                        color: AppColors().grey(),
                      ),
                      Spaces().verticalSpace2(),
                      Flexible(
                        child: _store(contentMaxScreenWidth: contentMaxScreenWidth)
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  Widget _appName() {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          colors: [Colors.orange, Colors.yellow],
        ).createShader(bounds);
      },
      blendMode: BlendMode.srcATop,
      child: Text(AppNames().appName, style: AppTextStyle().boldHeader(context: context),)
    );
  }

  Widget _user({required double contentMaxScreenWidth}) {
    return Container(
      height: 80,
      width: min(500, contentMaxScreenWidth),
      decoration: BoxDecoration(
        color: AppColors().appBackgroundColor(context: context),
        borderRadius: BorderRadius.circular(200),
        border: Border.all(color: AppColors().grey()),
        boxShadow: const [
          BoxShadow(color: Color(0x1F000000), blurRadius: 5)
        ]
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(200),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const EditUserInfoScreen(heroTagForImage: 'userInfo')));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ShowRoundImage(image: context.watch<UserDataController>().userImage, height: 60, width: 60, borderRadius: 800000),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        ((currentUserInfo == null || currentUserInfo!.fullName == '') ? (FirebaseAuthRepoImpl().currentUser!.email) : (currentUserInfo!.fullName)) ?? 'user name', style: AppTextStyle().normalSize(context: context),
                      ),
                    )
                  ],
                ),
                Center(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(500000),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const EditUserInfoScreen(heroTagForImage: 'blank')));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.settings, size: 30, color: AppColors().appActionColor(context: context),),
                    )
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _store({required double contentMaxScreenWidth}) {
    return Container(
      width: min(500, contentMaxScreenWidth),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        border: Border.all(color: AppColors().grey()),
        boxShadow: const [
          BoxShadow(color: Color(0x1F000000), blurRadius: 5)
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Your stores', style: AppTextStyle().greyBoldNormalSize(context: context),),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      showModalBottomSheet(
                        context: context, 
                        builder: (context) => CreateStore(
                        onCreateDone: () {
                          Navigator.pop(context);
                          // setState(() {
                            
                          // });
                        },
                      ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.add, size: 20,color: AppColors().appActionColor(context: context),),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text('Create', style: AppTextStyle().actionBoldNormalSize(context: context),),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          //Spaces().verticalSpace1(),
          Flexible(
            child: StoreList(contentMaxScreenWidth: contentMaxScreenWidth)
          )
        ],
      ),
    );
  }
}