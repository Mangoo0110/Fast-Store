import 'dart:async';
import 'dart:typed_data';

import 'package:easypos/common/data/app_regexp.dart';
import 'package:easypos/common/widgets/description_textfield.dart';
import 'package:easypos/common/widgets/name_textfield.dart';
import 'package:easypos/common/widgets/num_textfield.dart';
import 'package:easypos/data/datasources/firebase/firebase_image_repo_impl.dart';
import 'package:easypos/data/datasources/firebase/firebase_product_repo_impl.dart';
import 'package:easypos/models/product_model.dart';
import 'package:easypos/models/store_model.dart';
import 'package:easypos/pages/store/controller/store_data_controller.dart';
import 'package:easypos/common/widgets/image_show_upload_widget.dart';
import 'package:easypos/pages/store/screens/inventory/widgets/piece_kilo_switch_widget.dart';
import 'package:easypos/pages/store/screens/inventory/widgets/product_buying_selling_price_widget.dart';
import 'package:easypos/pages/store/screens/inventory/widgets/product_stock_add_subtract.dart';
import 'package:easypos/pages/store/screens/inventory/widgets/select_categories_of_product.dart';
import 'package:easypos/utils/app_colors.dart';
import 'package:easypos/utils/app_sizes.dart';
import 'package:easypos/utils/app_textstyles.dart';
import 'package:easypos/utils/dekhao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class CreateOrUpdateProduct extends StatefulWidget {
  final String heroTagForImage;
  final VoidCallback onCreateDone;
  final ProductModel? updatingProduct;
  final Uint8List? productImage;
  const CreateOrUpdateProduct({
    super.key,
    required this.onCreateDone,
    required this.updatingProduct,
    required this.heroTagForImage,
    required this.productImage,
  });

  @override
  State<CreateOrUpdateProduct> createState() => _CreateOrUpdateProductState();
}

class _CreateOrUpdateProductState extends State<CreateOrUpdateProduct> {

  late ProductModel editingProduct;

  TextEditingController productNameInputcontroller = TextEditingController();
  TextEditingController productDescriptionInputcontroller =
      TextEditingController();
  
  Uint8List? productImage;
  bool imageChanged = false;

  // double
  double productPrice = 0.0;

  //bool
  bool kiloLitreProduct = true, pieceProduct = false;

  //string
  String productName = '';

  //formKeys::
  final _productNameformKey = GlobalKey<FormState>();
  

  //sets ::
  Set<String> selectedCategorySet = {};

  // lists ::
  List<String> storeCategoryList = [];

  // functions

  _initiateEditingProduct() {
    final StoreModel currentStore =
          context.read<StoreDataController>().currentStore!;
          
    return ProductModel(
        productId: widget.updatingProduct != null
            ? widget.updatingProduct!.productId
            : FirebaseProductRepoImpl()
                .getProductIdForNewProduct(storeId: currentStore.storeId),
        itemBarcode: widget.updatingProduct != null
            ? widget.updatingProduct!.itemBarcode 
            : '',
        productName: productNameInputcontroller.text.trim(),
        productDescription: productDescriptionInputcontroller.text.trim(),
        productPrice: widget.updatingProduct != null
            ? widget.updatingProduct!.productPrice
            : 0,
        productionCost: widget.updatingProduct != null
            ? widget.updatingProduct!.productionCost
            : 0,
        stockCount: widget.updatingProduct != null
            ? widget.updatingProduct!.stockCount
            : 0,
        productCategoryList:
            selectedCategorySet.map((category) => category).toList(),
        productImageId: widget.updatingProduct != null
            ? widget.updatingProduct!.productImageId
            : FirebaseImageRepoImpl().newImageId(),
        pieceProduct: pieceProduct,
        kiloLitreProduct: kiloLitreProduct,
        soldFrequency: widget.updatingProduct != null
            ? widget.updatingProduct!.soldFrequency
            : 0,
        quantityMapFrequency: (widget.updatingProduct == null ||
                widget.updatingProduct!.quantityMapFrequency == {})
            ? {1: 0}
            : widget.updatingProduct!.quantityMapFrequency,
        ignoreStockOut: false
      );
  }

  Future<void> _createProduct() async {
    if (_productNameformKey.currentState!.validate() &&
        mounted) {
      final StoreModel currentStore = context.read<StoreDataController>().currentStore!;

      ProductModel newOrUpdateProduct = editingProduct;

      if (imageChanged && productImage != null) {
        await FirebaseImageRepoImpl().uploadImage(
            imageBytes: productImage!, imageId: newOrUpdateProduct.productImageId);
      }
      if(newOrUpdateProduct.props == widget.updatingProduct!.props) {
        if (mounted) {
          Navigator.pop(context);
        }
        return;
      }
      await FirebaseProductRepoImpl().createOrUpdateProduct(
              newProduct: newOrUpdateProduct, storeId: currentStore.storeId, productImage: null)
          .then((result) => result.fold((dataFailure) {
                Fluttertoast.showToast(
                    msg: "Failed! \n ${dataFailure.message}");
              }, (success) {
                Fluttertoast.showToast(
                    msg: widget.updatingProduct != null
                        ? 'Product is updated.'
                        : 'Product is created.');
                if (mounted) {
                  Navigator.pop(context);
                }
              }));
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    if (widget.updatingProduct != null) {
      selectedCategorySet =
          (widget.updatingProduct!.productCategoryList.toSet());
      selectedCategorySet.remove('All Products');
      productName = widget.updatingProduct!.productName;
      productPrice = widget.updatingProduct!.productPrice;
      pieceProduct = widget.updatingProduct!.pieceProduct;
      kiloLitreProduct = widget.updatingProduct!.kiloLitreProduct;
    }
    productImage = widget.productImage;
    productNameInputcontroller.text = productName;
    editingProduct = _initiateEditingProduct();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    productDescriptionInputcontroller.dispose();
    productNameInputcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _initiateEditingProduct();
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Align(
              alignment: Alignment.topLeft,
              child: Text(
                widget.updatingProduct != null
                    ? "Update Product "
                    : "New Product",
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
                await _createProduct();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.updatingProduct == null ? 'Create' : 'Update',
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppColors().grey()),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const[
                          BoxShadow(color: Color(0x1F000000), blurRadius: 5)
                        ]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10),
                        child: Column(
                          children: [
                            ImageShowUploadWidget(
                              heroTagForImage: widget.heroTagForImage,
                              image: productImage,
                              onUpload: (image) {
                                productImage = image;
                                imageChanged = true;
                              },
                            ),
                            SizedBox(
                              height: 75,
                              child: Form(
                                key: _productNameformKey,
                                child: NameTextfield(
                                  maxLines: 1,
                                  onChanged: (text) {
                                    if (mounted) {
                                      _productNameformKey.currentState!.validate();
                                    }
                                  },
                                  controller: productNameInputcontroller,
                                  hintText: '(Product name)',
                                  labelText: "Product name",
                                  validationCheck: (text) {
                                    if (selectedCategorySet.contains(text)) {
                                      return "Already exist";
                                    }
                                    if (text.isEmpty) {
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
                    SizedBox(
                      height: AppSizes().verticalSpace2,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppColors().grey()),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const[
                          BoxShadow(color: Color(0x1F000000), blurRadius: 5)
                        ]
                      ),
                      child: Column(
                        children: [
                          _buyingSellingPrice(),
                          const SizedBox(
                            height: 10,
                          ),
                          _kiloPieceSwitchAndStock(constraints: constraints),
                        ],
                      ),
                    ),
                    
                    const SizedBox(
                      height: 10,
                    ),
                    _selectShowCategoies(constraints: constraints),
                    
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 200,
                      child: DescriptionTextfield(
                        maxLines: 100,
                        onChanged: (text) {},
                        controller: productDescriptionInputcontroller,
                        hintText: 'Write something about the product',
                        labelText: "Description",
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: widget.updatingProduct == null
                      ? Container()
                      : _deleteProduct(constraints: constraints),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buyingSellingPrice() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4),
        child: ProductBuyingSellingPrice(
          product: editingProduct, 
          afterEditProduct:(afterEditProduct) { 
            editingProduct = afterEditProduct;
          },),
      ));
  }

  Widget _deleteProduct({required BoxConstraints constraints}) {
    dekhao('this delete button');
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.red.shade100),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const[
          BoxShadow(color: Color(0x1F000000), blurRadius: 8)
        ]
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          splashColor: Colors.red.shade400,
          onTap: () async {
            await FirebaseProductRepoImpl()
                .deleteAProduct(
                    productId: widget.updatingProduct!.productId,
                    storeId:
                        context.read<StoreDataController>().currentStore!.storeId)
                .then((dataResult) {
              dataResult.fold((failure) {
                Fluttertoast.showToast(msg: 'Failed: ${failure.message}');
              }, (success) {
                Navigator.pop(context);
              });
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: AppSizes().header,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    'Delete this product',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: AppSizes().normalText,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _kiloPieceSwitchAndStock({required BoxConstraints constraints}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        // border: Border.all(color: AppColors().grey()),
        // borderRadius: BorderRadius.circular(8),
        // boxShadow: const[
        //   BoxShadow(color: Color(0x1F000000), blurRadius: 8)
        // ]
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 4),
        child: ProductStockAddSubtractWidget(
          product: editingProduct, 
          onStockChange:(afterEditProduct) { 
            editingProduct = afterEditProduct;
          }),
      ),
    );
  }

  Widget _selectShowCategoies({required BoxConstraints constraints}) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors().grey(), borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: SelectShowCategoriesWidget(
          selectedCategorySet: selectedCategorySet,
          onSelect: (newSelectedCategorySet) {
            selectedCategorySet = newSelectedCategorySet;
          },
        ),
      ),
    );
  }
}
