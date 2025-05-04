import 'package:flutter/material.dart';
import 'package:native_app/models/favorite_place_model.dart';
import 'package:native_app/screens/favorite_place_details.dart';
import 'package:native_app/widgets/favorite_place.dart';
import 'package:native_app/screens/new_place.dart';

class FavoritePlaceList extends StatefulWidget {
  const FavoritePlaceList({super.key});

  @override
  State<FavoritePlaceList> createState() => _FavoritePlaceListState();
}

class _FavoritePlaceListState extends State<FavoritePlaceList> {
  List<FavoritePlaceModel> favoriteList = [
    FavoritePlaceModel(title: "Damascus")
  ];

  void _addPlaceWidget() async {
    final FavoritePlaceModel placeTitle = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewPlace(),
      ),
    );
    setState(() {
      favoriteList.add(placeTitle);
    });
  }

  void _removePlace(int index, FavoritePlaceModel place) {
    setState(() {
      favoriteList.removeAt(index);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            setState(() {
              favoriteList.insert(index, place);
            });
          },
        ),
        content: const Text("Place removed"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Places"),
        actions: [
          IconButton(
            onPressed: _addPlaceWidget,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: favoriteList.isEmpty
          ? const Center(
              child: Text(
                "No favorite places are added yet, try adding some !",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: favoriteList.length,
              itemBuilder: (context, index) => InkWell(
                splashColor: const Color.fromARGB(255, 81, 76, 105),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return FavoritePlaceDetails(
                        place: favoriteList[index],
                      );
                    },
                  ));
                },
                child: Dismissible(
                  key: ValueKey(favoriteList[index].id),
                  onDismissed: (direction) {
                    _removePlace(index, favoriteList[index]);
                  },
                  child: FavoritePlace(place: favoriteList[index]),
                ),
              ),
            ),
    );
  }
}
