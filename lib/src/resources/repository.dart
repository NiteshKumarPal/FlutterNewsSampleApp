import 'package:news_app/src/models/ItemModel.dart';

import 'news_api_provider.dart';
import 'news_db_provider.dart';

class Repository {
  List<Source> sources = <Source>[newsDbProvider, NewsApiProviders()];
  List<Cache> caches = <Cache>[newsDbProvider];

  Future<List<int>> fetchTopIds() {
    return sources[1].fetchTopIds();
  }

  Future<ItemModel> fetchItem(int id) async {
    ItemModel item;
    var source;

    for (source in sources) {
      item = await source.fetchItem(id);

      if (item != null) {
        print("item: ${item.title}");
        break;
      }
    }

    if (item != null) {
      for (var cache in caches) {
        if (cache != source) {
          cache.addItem(item);
        }
      }
    }

    return item;

//    try {
//      item = await newsDbProvider.fetchItem(id);
//    } catch (exception) {
//      item = await newsApiProvider.fetchItem(id);
//      newsDbProvider.addItem(item);
//
//      return item;
//    }
  }

  clearCaches() async {
    for (var cache in caches) {
      await cache.clear();
    }
  }
}

abstract class Source {
  Future<List<int>> fetchTopIds();
  Future<ItemModel> fetchItem(int id);
}

abstract class Cache {
  Future<int> addItem(ItemModel item);
  Future<int> clear();
}

final newsDbProvider = NewsDbProvider();
