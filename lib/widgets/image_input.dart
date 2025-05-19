import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onPickImage});
  //this functin is created to send the image to the new_place screen
  final void Function(File image) onPickImage;
  @override
  State<StatefulWidget> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;
  void pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _selectedImage = File(pickedImage.path);
    });

    widget
        .onPickImage(_selectedImage!); //cannot be null because we checked above
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      onPressed: pickImage,
      label: Text("Add Image"),
      icon: Icon(Icons.camera),
    );
    if (_selectedImage != null) {
      content = GestureDetector(
        onTap: () => pickImage(),
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Container(
          decoration: BoxDecoration(
            border: Border.all(
                width: 1, color: Theme.of(context).colorScheme.outline),
          ),
          height: 250,
          width: double.infinity,
          alignment: Alignment.center,
          child: content),
    );
  }
}
