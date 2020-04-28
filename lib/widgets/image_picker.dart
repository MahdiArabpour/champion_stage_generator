import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/permissions.dart';
import '../utils/toast.dart';

class MyImagePicker extends StatefulWidget {
  final double width;
  final double padding;

  const MyImagePicker({Key key, @required this.width, this.padding = 0})
      : super(key: key);

  @override
  _MyImagePickerState createState() => _MyImagePickerState();
}

class _MyImagePickerState extends State<MyImagePicker> {
  File _selectedFile;
  bool _inProcess = false;

  @override
  Widget build(BuildContext context) {
    return _inProcess
        ? _buildContainerBorder(child: CircularProgressIndicator())
        : GestureDetector(
            child: Container(
                padding: EdgeInsets.all(widget.padding),
                height: widget.width,
                width: widget.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                  child: _selectedFile == null
                      ? _buildContainerBorder(
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.add_photo_alternate,
                                  color: Colors.blueGrey,
                                ),
                              ),
                            ),
                          ),
                        )
                      : Image.file(_selectedFile),
                )),
            onTap: _pickImageDialog,
          );
  }

  Widget _buildContainerBorder({Widget child}) => Container(
        height: widget.width,
        width: widget.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
          border: Border.all(
              width: 2, color: Colors.blueGrey, style: BorderStyle.solid),
        ),
        child: child,
      );

  void _pickImageDialog() {
    final navigator = Navigator.of(context);
    showDialog(
      context: context,
      child: AlertDialog(
        titlePadding: EdgeInsets.all(8.0),
        title: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: const Text('Import from camera'),
              onTap: () async {
                if (await allowedCameraPermission()) {
                  if (navigator.canPop()) navigator.pop();
                  _pickImage(source: ImageSource.camera);
                } else
                  Toast.show('Access denied');
              },
            ),
            ListTile(
              leading: Icon(Icons.image),
              title: const Text('Import from gallery'),
              onTap: () async {
                if (await allowedStoragePermission()) {
                  if (navigator.canPop()) navigator.pop();
                  _pickImage(source: ImageSource.gallery);
                } else
                  Toast.show('Access denied');
              },
            ),
          ],
        ),
      ),
    );
  }

  _pickImage({ImageSource source}) async {
    this.setState(() => _inProcess = true);
    File image = await ImagePicker.pickImage(source: source);
    if (image != null) {
      File croppedImage = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatio: CropAspectRatio(
            ratioX: 1,
            ratioY: 1,
          ),
          compressQuality: (85 * 0.85).round(),
          maxWidth: (MediaQuery.of(context).size.width * 85).floor(),
          maxHeight: (MediaQuery.of(context).size.width * 85).floor(),
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
            toolbarColor: Theme.of(context).primaryColor,
            toolbarTitle: 'Crop your fucking image',
            backgroundColor: Colors.white,
          ));
      this.setState(() {
        _selectedFile = croppedImage;
        _inProcess = false;
      });
    } else
      setState(() => _inProcess = false);
  }
}
