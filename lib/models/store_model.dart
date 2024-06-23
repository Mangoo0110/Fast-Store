import 'package:easypos/data/data_field_names/data_field_names.dart';

/// before releasing app do remember to change createdAt field from String to timestamp
/// since firebase supports timestamp datatype
class StoreModel {
  final String storeId;
  final String parentStoreId;
  final String storeName;
  final String storeImageId;
  final String storeAddress;
  final String aboutStore;
  final String storeType;
  final int totalProductCategories;
  /// createdAt is a field that contains the utc date and time data as string of when the store is first time created
  final String createdAt;

  StoreModel({required this.createdAt, required this.storeId, required this.parentStoreId, required this.storeName, required this.storeImageId, required this.storeAddress, required this.aboutStore, required this.storeType, required this.totalProductCategories});

  factory StoreModel.fromMap({required Map<String, dynamic> map}) {
    return StoreModel(
      storeId: map[kstoreId] ?? '', 
      parentStoreId: map[kparentStoreId] ?? '', 
      storeName: map[kstoreName] ?? '', 
      storeImageId: map[kstoreImageId] ?? '', 
      storeAddress: map[kstoreAddress] ?? '', 
      aboutStore: map[kaboutStore] ?? '', 
      storeType: map[kstoreType] ?? '', 
      totalProductCategories: map[ktotalProductCategories] ?? '',
      createdAt: map[kcreatedAt] ?? '' 
    );
  }

  toMap (){
    return {
      kstoreId : storeId,
      kparentStoreId : parentStoreId,
      kstoreName : storeName,
      kstoreImageId : storeImageId,
      kstoreAddress : storeAddress,
      kaboutStore : aboutStore,
      kstoreType :storeType,
      ktotalProductCategories :totalProductCategories,
      kcreatedAt : createdAt
    };
  }
}