import 'dart:async';
import 'dart:math';

import 'package:easypos/core/failure.dart';
import 'package:easypos/data/datasources/firebase/firebase_store_repo_impl.dart';
import 'package:easypos/data/datasources/local/hive_store_repo_impl.dart';
import 'package:easypos/models/store_model.dart';
import 'package:easypos/pages/store/controller/store_data_controller.dart';
import 'package:easypos/pages/store/screens/main/store_view.dart';
import 'package:easypos/utils/app_colors.dart';
import 'package:easypos/utils/app_textstyles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class StoreList extends StatefulWidget {
  final double contentMaxScreenWidth;
  const StoreList({super.key, required this.contentMaxScreenWidth});

  @override
  State<StoreList> createState() => _StoreListState();
}

class _StoreListState extends State<StoreList> {

  final StreamController<List<StoreModel>> _storeListStreamController = StreamController<List<StoreModel>>() ;

  // functions
  populateStoreList() {
    RemoteStoreDataSourceImpl().fetchAllStoresOfUser()
      .fold(
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
        (storeListStream) {
          storeListStream.listen((List<StoreModel> data) {
            _storeListStreamController.add(data);
          }, onError: (error) {
            // Handle errors if needed
            _storeListStreamController.addError(error);
          }, onDone: () {
            // Close the controller when the input stream is done
            _storeListStreamController.close();
          });
          //Fluttertoast.showToast(msg: "Congrats! Your store is build and ready.");
        }
      );
  }

  Future<void> _navigateToStoreAfterCachingLocally({required StoreModel store}) async{
    await HiveStoreRepoImpl().setCurrentStoreInfo(store: store)
    .then((value) async{
      await context.read<StoreDataController>().init(context: context).then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const StoreView()), (route) => false));
    })
    .catchError((err){
      Fluttertoast.showToast(msg: err.toString());
    });
  }

  List<StoreModel> storeList = [];


  @override
  void initState() {
    // TODO: implement initState
    populateStoreList();
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return StreamBuilder(
          stream: _storeListStreamController.stream,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.done || ConnectionState.active:
                if(snapshot.hasData) {
                  storeList = snapshot.data as List<StoreModel>;
                  if(storeList.isEmpty) {
                    return Container(
                      //height: min(constraints.maxHeight, 100),
                      width: min(500, widget.contentMaxScreenWidth),
                      decoration: BoxDecoration(
                        color: AppColors().grey(),
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: Center(
                        child: Text(
                          'No stores to show', style: AppTextStyle().greyBoldNormalSize(context: context),
                        ),
                      ),
                    );
                  } else {
                    return  ListView.builder(
                      clipBehavior: Clip.hardEdge,
                      shrinkWrap: true,
                      itemCount: storeList.length,
                      itemBuilder: (context, index) {
                        StoreModel store = storeList[index];
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(2),
                            onTap: () async{
                              await _navigateToStoreAfterCachingLocally(store: store);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 6),
                              child: SizedBox(
                                height: 100,
                                width: min(500, widget.contentMaxScreenWidth),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: CircleAvatar(
                                        radius: 35,
                                        backgroundColor: AppColors().grey(),
                                        child: const Icon(Icons.image, size: 50,),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4),
                                      child: Text(
                                        storeList[index].storeName, style: AppTextStyle().normalSize(context: context),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                } else {
                  return const Center(child: Text('Error from service!!'));
                }
              default: 
                return const Center(child: CircularProgressIndicator());
            }
          },
        );
      },
    );
  }
}