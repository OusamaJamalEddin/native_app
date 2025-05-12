import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/models/favorite_place_model.dart';
import 'package:native_app/providers/favorite_place_provider.dart';

class NewPlace extends ConsumerStatefulWidget {
  const NewPlace({super.key});

  @override
  ConsumerState<NewPlace> createState() => _NewPlaceState();
}

class _NewPlaceState extends ConsumerState<NewPlace> {
  String? _enteredName;
  final _formKey = GlobalKey<FormState>();

  void _saveInput() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ref.read(favoritePlaceProvider.notifier).addPlace(
            FavoritePlaceModel(title: _enteredName!),
          );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a new place"),
      ),
      body: Container(
        padding: EdgeInsets.all(24),
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
              ElevatedButton.icon(
                onPressed: () {
                  _saveInput();
                },
                icon: Icon(Icons.add),
                label: Text(" Add Place"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
