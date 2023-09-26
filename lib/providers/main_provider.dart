import 'dart:developer';
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
  log("get database");

  return db;
}

class ListManipulator extends StateNotifier<List<Place>> {
  ListManipulator() : super(const []);
  WidgetRef? ref;

  Future<void> loadPlaces() async {
    log("hjkhjhhjhghhhhhhhhh");

    final db = await getDataBase();
    final data = await db.query('user_places');
    log(data.toString());
    log("hjkhjhhjhghhhhhhhhh");

    var places = data
        .map(
          (row) => Place(
              id: row['id'] as String,
              title: row['title'] as String,
              image: File(row['image'] as String)),
        )
        .toList();
    log(places.toString());
    state = places;
  }

  void add(String title, File image) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    var pickedImages = await image.copy("${appDir.path}/$fileName");
    log(pickedImages.toString());
    final item = Place(
      image: pickedImages,
      title: title,
    );
    state = [...state, item];
    final db = await getDataBase();
    log(state.toString());

    await db.insert(
      'user_places',
      {'id': item.id, 'title': item.title, 'image': item.image.path},
    );
    log("add item");
  }

  void remove(Place item) async {
    state = state.where((element) => element != item).toList();
    final db = await getDataBase();
    await db.delete('user_places', where: 'id == ?', whereArgs: [item.id]);
    log("remove item");
    log(state.toString());
  }
}

final listProvider = StateNotifierProvider<ListManipulator, List<Place>>((ref) {
  return ListManipulator();
});
