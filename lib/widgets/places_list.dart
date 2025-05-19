import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/models/favorite_place_model.dart';
import 'package:native_app/providers/favorite_place_provider.dart';
import 'package:native_app/screens/place_details.dart';

class PlacesList extends ConsumerStatefulWidget {
  const PlacesList({super.key, required this.placesList});
  final List<FavoritePlaceModel> placesList;
  @override
  ConsumerState<PlacesList> createState() => _PlacesListState();
}

class _PlacesListState extends ConsumerState<PlacesList> {
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
    Widget content = widget.placesList.isEmpty
        ? const Center(
            child: Text(
              "No favorite places are added yet, try adding some !",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          )
        : ListView.builder(
            itemCount: widget.placesList.length,
            itemBuilder: (context, index) {
              return Dismissible(
                onDismissed: (direction) =>
                    removePlace(index, widget.placesList[index]),
                key: ValueKey(widget.placesList[index].id),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: FileImage(widget.placesList[index].image),
                  ),
                  title: Text(
                    widget.placesList[index].title,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  subtitle: Text(
                    widget.placesList[index].location.address,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return PlaceDetails(place: widget.placesList[index]);
                        },
                      ),
                    );
                  },
                ),
              );
            },
          );
    return content;
  }
}
