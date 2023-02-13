import 'dart:developer';

import 'package:clean_architecture/data/failures/error_handler.dart';
import 'package:clean_architecture/data/responses/response.dart';
import 'package:clean_architecture/domain/models/models.dart';

abstract class LocalDataSource {
  Future<HomeResponse> getHomeData();
  Future<void> storeHomeData(HomeResponse homeResponse);
  Future<StoreDetailsResponse> getItemDetails();
  Future<void> storeItemDetails(StoreDetailsResponse storeDetailsResponse);

  clearCache();
  // law 3iza amsa7 7aga mo3ina mn el cache 3lshan yet3mlha reload tani mn el remote data source zay el favourites list
  removeFromCache(String key);
}

const String cacheHomeKey = "CACHE_HOME_KEY";
const String cacheStoreDetailsKey = "CACHE_STORE_DETAILS_KEY";
const int expirationTimeinMilliSec = 60 * 1000; // 1 minute in milliseconds

class LocalDataSourceImpl implements LocalDataSource {
  // create map for caching data in Runtime
  Map<String, CachedItems> cachedMap = Map();

  @override
  Future<HomeResponse> getHomeData() async {
    CachedItems? cachedItems = cachedMap[cacheHomeKey];

    if (cachedItems != null && cachedItems.isValid(expirationTimeinMilliSec)) {
      // return response from cache
      return cachedItems.data;
    } else {
      // return an cache error
      throw ErrorHandler.handle(DataSource.CACHE_ERROR);
    }
  }

  @override
  Future<void> storeHomeData(HomeResponse homeResponse) async {
    cachedMap[cacheHomeKey] = CachedItems(homeResponse);
  }

  @override
  Future<StoreDetailsResponse> getItemDetails() async {
    CachedItems? cachedItems = cachedMap[cacheStoreDetailsKey];

    if (cachedItems != null && cachedItems.isValid(expirationTimeinMilliSec)) {
      // return response from cache
      return cachedItems.data;
    } else {
      // return an cache error
      throw ErrorHandler.handle(DataSource.CACHE_ERROR);
    }
  }

  @override
  Future<void> storeItemDetails(
      StoreDetailsResponse storeDetailsResponse) async {
    cachedMap[cacheStoreDetailsKey] = CachedItems(storeDetailsResponse);
  }

  @override
  clearCache() {
    cachedMap.clear();
  }

  @override
  removeFromCache(String key) {
    cachedMap.remove(key);
  }
}

class CachedItems {
  dynamic data;

  // storing time when the data was cached
  int cacheTime = DateTime.now().millisecondsSinceEpoch;

  CachedItems(this.data);
}

extension CachedItemsExtension on CachedItems {
  // kol 60 sec yro7 ygeb el data mn el API w khelal el 60 sec ygeb el data mn el cache
  // 3lshan mayefdalsh yeb3at get request kol mara akhosh fiha el screen; yeb3at bs kol 60 sec
  bool isValid(int expirationTimeinMilliSec) {
    int currentTimeinMilliSec = DateTime.now().millisecondsSinceEpoch;

    return currentTimeinMilliSec - cacheTime <= expirationTimeinMilliSec;

    // expirationTimeInMilliSec -> 60 sec
    // currentTimeInMilliSec -> 1:00:00
    // cacheTime -> 12:59:30
    // 30 seconds < 60 seconds so, it is valid
  }
}
