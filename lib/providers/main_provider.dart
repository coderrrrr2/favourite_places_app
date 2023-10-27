import 'dart:io';

import 'package:favourite_places_app/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> getDataBase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(path.join(dbPath, 'placesDB.db'),
      onCreate: (db, version) {
    return db.execute(
        "CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT)");
  }, version: 1);

  return db;
}

class ListManipulator extends StateNotifier<List<Place>> {
  ListManipulator() : super(const []);
  WidgetRef? ref;

  Future<void> loadPlaces() async {
    final db = await getDataBase();
    final data = await db.query('user_places');

    var places = data
        .map(
          (row) => Place(
              id: row['id'] as String,
              title: row['title'] as String,
              image: File(row['image'] as String)),
        )
        .toList();

    state = places;
  }

  void add(String title, File image) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    var pickedImages = await image.copy("${appDir.path}/$fileName");
    final item = Place(
      image: pickedImages,
      title: title,
    );
    state = [...state, item];
    final db = await getDataBase();

    await db.insert(
      'user_places',
      {'id': item.id, 'title': item.title, 'image': item.image.path},
    );
  }

  void remove(Place item) async {
    state = state.where((element) => element != item).toList();
    final db = await getDataBase();
    await db.delete('user_places', where: 'id == ?', whereArgs: [item.id]);
  }
}

final listProvider = StateNotifierProvider<ListManipulator, List<Place>>((ref) {
  return ListManipulator();
});
