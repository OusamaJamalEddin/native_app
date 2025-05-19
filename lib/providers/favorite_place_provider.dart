import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/models/favorite_place_model.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite/sqflite.dart' as sql;

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, "places.db"),
    onCreate: (db, version) => db.execute(
        "CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)"),
    version: 1,
  );
  return db;
}

class FavoritePlaceNotifier extends StateNotifier<List<FavoritePlaceModel>> {
  FavoritePlaceNotifier() : super([]);

  Future<void> loadPlaces() async {
    final db = await _getDatabase();
    final data = await db.query("user_places");
    final places = data
        .map(
          (row) => FavoritePlaceModel(
            id: row['id'] as String,
            title: row['title'] as String,
            image: File(row['image'] as String),
            location: PlaceLocation(
                latitude: row['lat'] as double,
                longitude: row['lng'] as double,
                address: row['address'] as String),
          ),
        )
        .toList();
    state = places;
  }

  void addPlace(String title, PlaceLocation location, File image) async {
    //this process is just to save the images in the device
    // we arte first taking the directory then file name then making a copy of the image and store it in the sql database of the local device
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    final copiedImage = await image.copy('${appDir.path}/$fileName');
    final place = FavoritePlaceModel(
        title: title, image: copiedImage, location: location);
    final db = await _getDatabase();
    db.insert("user_places", {
      "id": place.id,
      "title": place.title,
      "image": place.image.path,
      "lat": place.location.latitude,
      "lng": place.location.longitude,
      "address": place.location.address
    });
    state = [place, ...state];
  }

  void removePlace(int index) {
    state = [...state]..removeAt(index);
  }

  void undoRemove(int index, FavoritePlaceModel place) {
    state = [...state]..insert(index, place);
  }
}

final favoritePlaceProvider =
    StateNotifierProvider<FavoritePlaceNotifier, List<FavoritePlaceModel>>(
  (ref) {
    return FavoritePlaceNotifier();
  },
);
