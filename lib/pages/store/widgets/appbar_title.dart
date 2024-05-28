import 'package:easypos/pages/store/screens/appdrawer/controller/appdrawer_controller.dart';
import 'package:easypos/pages/store/screens/appdrawer/screens/appdrawer.dart';
import 'package:easypos/utils/app_textstyles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppbarTitleWidget extends StatefulWidget {
  const AppbarTitleWidget({super.key});

  @override
  State<AppbarTitleWidget> createState() => _AppbarTitleWidgetState();
}

class _AppbarTitleWidgetState extends State<AppbarTitleWidget> {
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          colors: [Colors.orange, Colors.yellow],
        ).createShader(bounds);
      },
      blendMode: BlendMode.srcATop,
      child: Text(_appBarTitle(), style: AppTextStyle().boldBigSize(context: context),)
    );
  }
  String _appBarTitle() {
    AppDrawerTabState appDrawerTabState = context.watch<AppdrawerProviderController>().selectedAppDrawerTab;
    if(appDrawerTabState == AppDrawerTabState.billing) {
      return  'B I L L I N G';
    } else if(appDrawerTabState == AppDrawerTabState.analysis) {
      return  'A N A L Y S I S';
    } else if(appDrawerTabState == AppDrawerTabState.inventory) {
      return  'I N V E N T O R Y';
    } else if(appDrawerTabState == AppDrawerTabState.settings) {
      return  'B I L L I N G';
    } else {
      return  'S E T T I N G';
    }
  }
}