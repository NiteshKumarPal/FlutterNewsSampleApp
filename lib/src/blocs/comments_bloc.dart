import 'package:news_app/src/models/ItemModel.dart';
import 'package:news_app/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class CommentsBloc {
  final _repository = Repository();
  final _commentsFetcher = PublishSubject<int>();
  final _commentsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();

  //Streams getter
  Stream<Map<int, Future<ItemModel>>> get itemsWithComments =>
      _commentsOutput.stream;

  //Sink getter
  Function(int) get fetchitemsWithComments => _commentsFetcher.sink.add;

  CommentsBloc() {
    _commentsFetcher.stream
        .transform(_commentsTransformer())
        .pipe(_commentsOutput);
  }

  _commentsTransformer() {
    return ScanStreamTransformer(
        (Map<int, Future<ItemModel>> cache, int id, index) {
      print(index);
      cache[id] = _repository.fetchItem(id);
      cache[id].then((ItemModel item) {
        item.kids.forEach((kidId) => fetchitemsWithComments(kidId));
      });
      return cache;
    }, <int, Future<ItemModel>>{});
  }
}
