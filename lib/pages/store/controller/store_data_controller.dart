import 'dart:async';
import 'dart:typed_data';

import 'package:easypos/data/datasources/firebase/firebase_category_repo_impl.dart';
import 'package:easypos/data/datasources/firebase/firebase_image_repo_impl.dart';
import 'package:easypos/data/datasources/firebase/firebase_product_repo_impl.dart';
import 'package:easypos/data/datasources/local/hive_store_repo_impl.dart';
import 'package:easypos/models/product_model.dart';
import 'package:easypos/models/store_model.dart';
import 'package:easypos/pages/user_auth/screens/signin.dart';
import 'package:easypos/utils/dekhao.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class StoreDataController extends ChangeNotifier{
  StoreModel? _currentStore;
  List<ProductModel> _productListOfStore = [];
  final Map<String, Uint8List?> _idMappedImages = {};
  Map<String, String> _categoryMapImageIdOfStore = {'All products' : ''};

  Map<String, String> get categoryMapImageIdOfStore => _categoryMapImageIdOfStore;
  
  List<ProductModel> get productListOfStore => _productListOfStore;

  Map<String, Uint8List?> get idMappedImages => _idMappedImages;

  StoreModel? get currentStore => _currentStore;

  Future<void> init({required BuildContext context}) async{
    await getCurrentStore(context: context).then((value) async{
      await fetchCategoriesOfStore();
      await fetchProductListOfStore();
    });
  }

  Future<StoreModel?> getCurrentStore({required BuildContext context}) async{
    if(currentStore != null) {
      return currentStore;
    }
    return await HiveStoreRepoImpl().currentStoreInfo().then((dataResult) => dataResult
    .fold(
        (dataFailure) {
          Fluttertoast.showToast(msg: "Failed! \n ${dataFailure.message}");
          return currentStore;
        } ,
        (store) {
          if(store == null) {
            Fluttertoast.showToast(msg: 'No store found!');
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> const SignInView()), (route) => false);
          } else {
            _currentStore = store;           
          }
          notifyListeners();
          return _currentStore;
        }
      )
    );
    
  }


  Future<void> getImages(Iterator<String> imageIdIterator) async{
    dekhao("Future<void> getImages(Iterator<ProductModel> productIterator) ${imageIdIterator.current}");
    if((!_idMappedImages.containsKey(imageIdIterator.current)) || (_idMappedImages[imageIdIterator.current] == null)) {
      await FirebaseImageRepoImpl().fetchImage(imageId: imageIdIterator.current)
      .then((dataResult) {
        dataResult
          .fold(
            (dataFailure) {
              _idMappedImages[imageIdIterator.current] = null;
            } ,
            (fetchedImage) {
              _idMappedImages[imageIdIterator.current] = fetchedImage;
              notifyListeners();
              if(imageIdIterator.moveNext()) {
                getImages(imageIdIterator);
              }
            }
          );
      });
    } else {
      if(imageIdIterator.moveNext()) {
        getImages(imageIdIterator);
      }
    }
  }

  updateImageWithImageIdLocally({required String imageId, required Uint8List newImage}) {
    _idMappedImages[imageId] = newImage;
  }

  Future<Map<String, String>> fetchCategoriesOfStore() async{
    dekhao('category list requested');
    return await FirebaseCategoryRepoImpl().fetchAllCategories(storeId: currentStore!.storeId)
      .then((dataResult) {
        return dataResult
          .fold(
            (dataFailure) {
              Fluttertoast.showToast(msg: "Failed! \n ${dataFailure.message}");
              return _categoryMapImageIdOfStore;
            } ,
            (categoryMapListStream) {
              categoryMapListStream.listen((data) {
                _categoryMapImageIdOfStore = data.categoryMapOfStore;
                notifyListeners();
              }, onError: (error) {
              }, onDone: () {
                // _categoryStreamController.close();
              });
              return _categoryMapImageIdOfStore;
            }
          );
      });
  }

  Future<List<ProductModel>> fetchProductListOfStore() async{
    dekhao('product list requested');
    return await FirebaseProductRepoImpl().fetchAllProducts(storeId: currentStore!.storeId)
      .then((dataResult) {
        return dataResult.fold(
          (dataFailure) {
            Fluttertoast.showToast(msg: "Failed! \n ${dataFailure.message}");
            return _productListOfStore;
          } ,
          (productListStream) {

            productListStream.listen((List<ProductModel> data) async{
              _productListOfStore = data;
              _productListOfStore.sort(((a, b) => a.productPrice.compareTo(b.productPrice)));
              _productListOfStore.sort(((a, b) => a.soldFrequency.compareTo(b.soldFrequency)));
              final imageIdIterator = _productListOfStore.map((product) => product.productImageId).toList().iterator;
              imageIdIterator.moveNext();
              await getImages(imageIdIterator);
              notifyListeners();
            }, onError: (error) {

            }, onDone: () {

            });
            return _productListOfStore;
          }
        );}
      );
  }
  Uint8List? imageIfExist({required String imageId}) {
    return _idMappedImages[imageId];
  }
}