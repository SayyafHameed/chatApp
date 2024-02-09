import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagesPicker extends StatefulWidget {
  const UserImagesPicker({ Key? key, required this.onImagePick }) : super(key: key);

  final void Function(File imagePecker) onImagePick;

  @override
  // ignore: library_private_types_in_public_api
  _UserImagesPickerState createState() => _UserImagesPickerState();
}

class _UserImagesPickerState extends State<UserImagesPicker> {

  File? _imagePickerFile;

  void _imagePicker() async{
    final XFile? imagePicked = await ImagePicker().pickImage(source: ImageSource.camera, maxWidth: 150, imageQuality: 50,);

    if(imagePicked == null ){
      return;
    }
    setState(() {
      _imagePickerFile = File(imagePicked.path);
    });

    widget.onImagePick(_imagePickerFile!);
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage: _imagePickerFile == null ? null : FileImage(_imagePickerFile!),
        ),
        TextButton.icon(onPressed: _imagePicker, icon: const Icon(Icons.image), label: Text('Add Image', style: TextStyle(color: Theme.of(context).primaryColor,),),),
      ],
    );
  }
}