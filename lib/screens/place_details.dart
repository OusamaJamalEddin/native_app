import 'package:flutter/material.dart';
import 'package:native_app/models/favorite_place_model.dart';

class PlaceDetails extends StatelessWidget {
  const PlaceDetails({super.key, required this.place});
  final FavoritePlaceModel place;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: Form(
          child: Center(
        child: Text(place.id),
      )),
    );
  }
}
