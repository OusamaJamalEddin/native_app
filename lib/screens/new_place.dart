import 'package:flutter/material.dart';
import 'package:native_app/models/favorite_place_model.dart';

class NewPlace extends StatefulWidget {
  const NewPlace({super.key});

  @override
  State<NewPlace> createState() => _NewPlaceState();
}

class _NewPlaceState extends State<NewPlace> {
  String? _enteredName;
  final _formKey = GlobalKey<FormState>();

  void _saveInput() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.of(context).pop(FavoritePlaceModel(title: _enteredName!));
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
                decoration: InputDecoration(
                  label: const Text("Enter a place"),
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
              ElevatedButton(
                  onPressed: () {
                    _saveInput();
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add),
                      SizedBox(
                        width: 6,
                      ),
                      Text(" Add Place")
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
