import 'package:news_app/src/models/ItemModel.dart';
import 'package:news_app/src/resources/repository.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class NewsDbProvider implements Source, Cache {
  Database db;

  final _dbName = "items.db";
  final _tableName = "Items";

  NewsDbProvider() {
    init();
  }

  init() async {
    var documentDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentDirectory.path, _dbName);
    db = await openDatabase(path, version: 1,
        onCreate: (Database newDb, int version) {
      newDb.execute('''
          CREATE TABLE $_tableName
          (
             id INTEGER PRIMARY KEY,
             type TEXT,
             by TEXT,
             time INTEGER,
             text TEXT,
             parent INTEGER,
             kids BLOB,
             dead INTEGER,
             deleted INTEGER,
             url TEXT,
             score INTEGER,
             title TEXT,
             descendants INTEGER
          )    
           ''');
    });
  }

  Future<ItemModel> fetchItem(int id) async {
    final dbResults = await db
        .query(_tableName, columns: null, where: "id = ?", whereArgs: [id]);

    ItemModel itemModel;

    if (dbResults.length > 0) {
      itemModel = ItemModel.fromDb(dbResults.first);
      return itemModel;
    }
//    else {
//      throw Exception("Item not found");
//    }

    return null;
  }

  Future<int> addItem(ItemModel item) {
    return db.insert(_tableName, item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  @override
  Future<List<int>> fetchTopIds() {
    return null;
  }

  Future<int> clear() {
    return db.delete(_tableName);
  }
}

final newsDbProvider = NewsDbProvider();
