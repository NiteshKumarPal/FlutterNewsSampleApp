import 'package:news_app/src/models/ItemModel.dart';
import 'package:news_app/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class StoriesBloc {
  final _repository = Repository();
  final _topIds = PublishSubject<List<int>>();
  final _itemsfetcher = PublishSubject<int>();
  final _itemsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();

  //getter to get streams
  Stream<List<int>> get topIds => _topIds.stream;
  Stream<Map<int, Future<ItemModel>>> get items => _itemsOutput.stream;

  //getter to sink
  Function(int) get fetchItem => _itemsfetcher.sink.add;

  fetchTopIds() async {
    final ids = await _repository.fetchTopIds();
    _topIds.sink.add(ids);
  }

  StoriesBloc() {
    _itemsfetcher.stream.transform(_itemsTransformer()).pipe(_itemsOutput);
  }

  _itemsTransformer() {
    return ScanStreamTransformer(
        (Map<int, Future<ItemModel>> cache, int id, index) {
      print(index);
      cache[id] = _repository.fetchItem(id);
      return cache;
    }, <int, Future<ItemModel>>{});
  }

  clearCache() {
    return _repository.clearCaches();
  }

  dispose() {
    _topIds.close();
    _itemsfetcher.close();
    _itemsOutput.close();
  }
}
