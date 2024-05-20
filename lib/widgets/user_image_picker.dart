import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker({super.key, required this.setimage});

  void Function(File upfile) setimage;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile;

  //uploading file
  void _galImage() async {
    var _polo = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (_polo == null) {
      return;
    }
    setState(() {
      _pickedImageFile = File(_polo.path);
    });
    widget.setimage(_pickedImageFile!);
  }

  void _pickImage() async {
    var _pickedimage = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50, maxWidth: 200);
    if (_pickedimage == null) {
      return;
    }
    setState(() {
      _pickedImageFile = File(_pickedimage.path);
    });

    widget.setimage(_pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          foregroundImage:
              _pickedImageFile != null ? FileImage(_pickedImageFile!) : null,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextButton.icon(
                  onPressed: _pickImage,
                  icon: Icon(Icons.add_a_photo),
                  label: Text("Add Image")),
            ),
            Expanded(
              child: TextButton.icon(
                  onPressed: _galImage,
                  icon: Icon(Icons.upload_file),
                  label: Text("Upload Image")),
            ),
          ],
        )
      ],
    );
  }
}
