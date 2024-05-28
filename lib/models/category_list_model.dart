import 'package:easypos/data/data_field_names/data_field_names.dart';

class CategoryMapListModel {
  final Map<String, String> categoryMapOfStore;

  CategoryMapListModel({required this.categoryMapOfStore});

  factory CategoryMapListModel.fromMap({required Map<String, dynamic>map}) {
    final categoryMap = CategoryMapListModel(categoryMapOfStore: {'All products': ''}..addEntries( Map<String, String>.from(map[kCategoryMap]).entries));
    return categoryMap;
  }

  toMap() {
    return {
      kCategoryMap : categoryMapOfStore
    };
  }
}