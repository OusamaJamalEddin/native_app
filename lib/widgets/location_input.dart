import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:native_app/models/favorite_place_model.dart';
import 'package:native_app/screens/map_preview.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onPickLocation});
  //i created this function to send the location to the new_place screen (yes, i can do that)
  final Function(PlaceLocation location) onPickLocation;
  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  var _isGettingLocation = false;

  String get locationimage {
    final lat = _pickedLocation!.latitude;
    final lng = _pickedLocation!.longitude;
    //no need for http request here, because the image of the map can be created intantly without any requests as loong as we are providing the correct paramters (latitude and longitude also the api key)
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=13&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:S%7C40.702147,-74.015794&markers=color:green%7Clabel:G%7C40.711614,-74.012318&markers=color:red%7Clabel:Y%7C$lat,$lng&key=AIzaSyD8DJUfBPaXLm4RqWM_Lnckjvr3kfMUtlM';
  }

  void saveLocation(double lat, double lng) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=AIzaSyD8DJUfBPaXLm4RqWM_Lnckjvr3kfMUtlM');
    final response = await http.get(url);
    final decodedResponse = json.decode(response.body);
    final address = decodedResponse['results'][0]['formatted_address'];
    if (response.body.isEmpty || response.statusCode >= 400) {
      return;
    }

    setState(() {
      _pickedLocation =
          PlaceLocation(address: address, latitude: lat, longitude: lng);
      _isGettingLocation = false;
    });
    widget.onPickLocation(_pickedLocation!);
  }

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      _isGettingLocation = true;
    });
    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;
    if (lat == null || lng == null) {
      return;
    }
    saveLocation(lat, lng);
  }

  void selectOnMap() async {
    final pickedPosition = await Navigator.push<LatLng>(
      context,
      MaterialPageRoute(
        builder: (context) => MapPreview(),
      ),
    );
    if (pickedPosition == null) {
      return;
    }
    saveLocation(pickedPosition.latitude, pickedPosition.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget locationPreviewContent = Text(
      "Place not chosen yet",
      style: TextStyle(color: Theme.of(context).colorScheme.primary),
    );
    if (_isGettingLocation) {
      locationPreviewContent = const CircularProgressIndicator();
    }
    if (_pickedLocation != null) {
      locationPreviewContent = Image.network(
        locationimage,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      );
    }
    return Column(children: [
      Container(
          alignment: Alignment.center,
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
                width: 1, color: Theme.of(context).colorScheme.outline),
          ),
          child: locationPreviewContent),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton.icon(
            onPressed: _getCurrentLocation,
            label: const Text("Get current Location"),
            icon: const Icon(Icons.location_on),
          ),
          TextButton.icon(
            onPressed: selectOnMap,
            label: const Text("Select on Map"),
            icon: const Icon(Icons.map),
          )
        ],
      )
    ]);
  }
}
