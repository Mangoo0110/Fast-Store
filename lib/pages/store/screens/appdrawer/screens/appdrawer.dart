
import 'package:easypos/common/widgets/show_rect_image.dart';
import 'package:easypos/pages/store/screens/appdrawer/controller/appdrawer_controller.dart';
import 'package:easypos/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
enum AppDrawerTabState {billing, inventory, analysis, settings}

class AppDrawer extends StatefulWidget {
  final AppDrawerTabState selectedTab;
  final Function(AppDrawerTabState selectedTab) onNewTabSelect;
  const AppDrawer({required this.onNewTabSelect, super.key, required this.selectedTab});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  AppDrawerTabState appDrawerTabState = AppDrawerTabState.billing;
  @override
  void initState() {
    // TODO: implement initState
    appDrawerTabState = widget.selectedTab;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    appDrawerTabState = context.watch<AppdrawerProviderController>().selectedAppDrawerTab;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Drawer(
          backgroundColor: AppColors().appBackgroundColor(context: context),
          shape: const LinearBorder(side:  BorderSide()),
          child: ListView(
            children: [
              DrawerHeader(child: Container(),),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: ListTile(
                    leading: const Icon(Icons.monetization_on),
                    title: const Text("Billing"),
                    onTap: () {
                      if(appDrawerTabState != AppDrawerTabState.billing) {
                        appDrawerTabState = AppDrawerTabState.billing;
                        widget.onNewTabSelect(AppDrawerTabState.billing);
                        Scaffold.of(context).closeDrawer();
                      }
                    },
                    //tileColor: widget.appDrawerTabState == AppDrawerTabState.billing ? Colors.orange.shade200 : Colors.transparent,
                    selected: appDrawerTabState == AppDrawerTabState.billing,
                    selectedColor: Colors.orange.shade700,
                    selectedTileColor: Colors.orange.shade100,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: ListTile(
                    leading: const Icon(Icons.library_books),
                    title: const Text("Inventory"),
                    onTap: () {
                      if(appDrawerTabState != AppDrawerTabState.inventory) {
                        appDrawerTabState = AppDrawerTabState.inventory;
                        widget.onNewTabSelect(AppDrawerTabState.inventory);
                        Scaffold.of(context).closeDrawer();
                      }
                    },
                    //tileColor: widget.appDrawerTabState == AppDrawerTabState.inventory ? Colors.orange.shade200 : Colors.transparent,
                    selected: appDrawerTabState == AppDrawerTabState.inventory,
                    selectedColor: Colors.orange.shade700,
                    selectedTileColor: Colors.orange.shade100,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: ListTile(
                    leading: const Icon(Icons.auto_graph_outlined),
                    title: const Text("Analysis"),
                    onTap: () {
                      if(appDrawerTabState != AppDrawerTabState.analysis) {
                        appDrawerTabState = AppDrawerTabState.analysis;
                        widget.onNewTabSelect(AppDrawerTabState.analysis);
                        Scaffold.of(context).closeDrawer();
                      }
                    },
                    //tileColor: widget.appDrawerTabState == AppDrawerTabState.analysis ? Colors.orange.shade200 : Colors.transparent,
                    selected: appDrawerTabState == AppDrawerTabState.analysis,
                    selectedColor: Colors.orange.shade700,
                    selectedTileColor: Colors.orange.shade100,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text("Settings"),
                    onTap: () {
                      if(appDrawerTabState != AppDrawerTabState.settings) {
                        appDrawerTabState = AppDrawerTabState.settings;
                        widget.onNewTabSelect(AppDrawerTabState.settings);
                        Scaffold.of(context).closeDrawer();
                      }
                    },
                    //tileColor: widget.appDrawerTabState == AppDrawerTabState.settings ? Colors.orange.shade200 : Colors.transparent,
                    selected: appDrawerTabState == AppDrawerTabState.settings,
                    selectedColor: Colors.orange.shade700,
                    selectedTileColor: Colors.orange.shade100,
                  ),
                ),
              ),
            ],
          )
        );
      },
    );
  }

  // Widget _drawerHeader({required BoxConstraints constraints}) {
  //   return ShowSquareImag
  // }
}