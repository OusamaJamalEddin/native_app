import 'package:flutter/material.dart';
import 'package:native_app/models/favorite_place_model.dart';

class PlaceCard extends StatelessWidget {
  const PlaceCard({super.key, required this.place});
  final FavoritePlaceModel place;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: ListTile(
        title: Text(place.title),
      ),
    );
  }
}
