import 'package:uuid/uuid.dart';

final uuid = Uuid();

class FavoritePlaceModel {
  FavoritePlaceModel({required this.title}) : id = uuid.v4();
  String title;
  String id;
}
