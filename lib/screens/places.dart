import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/providers/favorite_place_provider.dart';
import 'package:native_app/screens/new_place.dart';
import 'package:native_app/widgets/places_list.dart';

class Places extends ConsumerStatefulWidget {
  const Places({super.key});

  @override
  ConsumerState<Places> createState() {
    return _PlacesState();
  }
}

class _PlacesState extends ConsumerState<Places> {
  late Future<void> _placesFuture;
  @override
  void initState() {
    super.initState();
    _placesFuture = ref.read(favoritePlaceProvider.notifier).loadPlaces();
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
      body: FutureBuilder(
        future: _placesFuture,
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : PlacesList(placesList: favoriteList),
      ),
    );
  }
}
