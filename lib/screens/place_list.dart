import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/models/favorite_place_model.dart';
import 'package:native_app/providers/favorite_place_provider.dart';
import 'package:native_app/screens/place_details.dart';
import 'package:native_app/widgets/place_card.dart';
import 'package:native_app/screens/new_place.dart';

class PlaceList extends ConsumerStatefulWidget {
  const PlaceList({super.key});

  @override
  ConsumerState<PlaceList> createState() => _PlaceListState();
}

class _PlaceListState extends ConsumerState<PlaceList> {
  void removePlace(int index, FavoritePlaceModel place) {
    ref.read(favoritePlaceProvider.notifier).removePlace(index);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            ref.read(favoritePlaceProvider.notifier).undoRemove(index, place);
          },
        ),
        content: const Text("Place removed"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoriteList = ref.watch(favoritePlaceProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Places"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewPlace(),
                ),
              );
            },
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
              itemBuilder: (context, index) {
                return InkWell(
                  splashColor: const Color.fromARGB(255, 81, 76, 105),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return PlaceDetails(
                          place: favoriteList[index],
                        );
                      },
                    ));
                  },
                  child: Dismissible(
                    key: ValueKey(favoriteList[index].id),
                    onDismissed: (direction) {
                      removePlace(index, favoriteList[index]);
                    },
                    child: PlaceCard(place: favoriteList[index]),
                  ),
                );
              },
            ),
    );
  }
}
