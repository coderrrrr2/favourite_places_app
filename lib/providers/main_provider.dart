import 'dart:io';

import 'package:favourite_places_app/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> getDataBase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(path.join(dbPath, 'places.db'),
      onCreate: (db, version) {
    return db.execute(
        "CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT)");
  }, version: 1);
  return db;
}

class ListManipulator extends StateNotifier<List<Place>> {
  ListManipulator() : super(const []);
  WidgetRef? ref;

  void loadPlaces() async {
    final db = await getDataBase();
    final data = await db.query('user_places');
    final places = data
        .map(
          (row) => Place(
              id: row['id'] as String,
              title: row['title'] as String,
              image: File(row['image'] as String)),
        )
        .toList();
    state = places;
  }

  void add(Place item) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(item.image.path);
    await item.image.copy("${appDir.path}/$fileName");

    state = [...state, item];
    final db = await getDataBase();
    db.insert(
      'user_places',
      {'id': item.id, 'title': item.title},
    );
  }

  void remove(Place item) {
    state = state.where((element) => element != item).toList();
  }
}

final listProvider = StateNotifierProvider<ListManipulator, List<Place>>((ref) {
  return ListManipulator();
});
