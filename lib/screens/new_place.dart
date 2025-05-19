import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/models/favorite_place_model.dart';
import 'package:native_app/providers/favorite_place_provider.dart';
import 'package:native_app/widgets/image_input.dart';
import 'package:native_app/widgets/location_input.dart';

class NewPlace extends ConsumerStatefulWidget {
  const NewPlace({super.key});

  @override
  ConsumerState<NewPlace> createState() => _NewPlaceState();
}

class _NewPlaceState extends ConsumerState<NewPlace> {
  File? _selectedImage;
  String? _enteredName;
  PlaceLocation? _selectedLocation;
  final _formKey = GlobalKey<FormState>();

  void _saveInput() {
    if (_formKey.currentState!.validate() &&
        _selectedImage != null &&
        _selectedLocation != null) {
      _formKey.currentState!.save();
      ref
          .read(favoritePlaceProvider.notifier)
          .addPlace(_enteredName!, _selectedLocation!, _selectedImage!);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a new place"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                onSaved: (newValue) => _enteredName = newValue,
                style: TextStyle(color: Colors.white),
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text("Enter a place"),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return "Name should be between 1 and 50 characters";
                  }
                  return null;
                },
              ),
              ImageInput(
                onPickImage: (image) {
                  //this way, i managed to receive the image taken from the camera from the imageinput widget
                  _selectedImage = image;
                },
              ),
              LocationInput(
                onPickLocation: (location) {
                  //this way, i managed to receive the location from the location_input widget
                  _selectedLocation = location;
                },
              ),
              ElevatedButton.icon(
                onPressed: () {
                  _saveInput();
                },
                icon: const Icon(Icons.add),
                label: const Text(" Add Place"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
