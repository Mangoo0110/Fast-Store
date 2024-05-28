// import 'package:easypos/data/data_field_names/data_field_names.dart';

// class CategoryModel {
//   final String categoryName;
//   final String categoryImageUrl;
//   final int totalProducts;

//   CategoryModel({required this.categoryName, required this.totalProducts ,required this.categoryImageUrl});

//   factory CategoryModel.fromMap(Map<String, dynamic> map) {
//     return CategoryModel(
//       categoryName: map[kproductName] ?? '',  
//       totalProducts: map[kstockCount] == null ? 0 : int.parse(map[kstockCount].toString()),
//       categoryImageUrl: map[kproductImageUrl] ?? ''
//     );
//   }

//   toMap() {
//     return {
//       kproductName : categoryName,
//       kstockCount : totalProducts,
//       kproductImageUrl : categoryImageUrl 
//     };
//   }
// }