import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/models/favorite_place_model.dart';

class FavoritePlaceNotifier extends StateNotifier<List<FavoritePlaceModel>> {
  FavoritePlaceNotifier() : super([]);

  void addPlace(FavoritePlaceModel place) {
    state = [...state, place];
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
