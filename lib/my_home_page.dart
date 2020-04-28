import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:save_in_gallery/save_in_gallery.dart';

import './widgets/description_text_input.dart';
import './blocs/description_text_bloc.dart';
import './utils/permissions.dart';
import './utils/toast.dart';
import './widgets/description_text.dart';
import './widgets/stage_slider.dart';

// ignore: must_be_immutable
class MyHomePage extends StatelessWidget {
  static DescriptionTextBloc _bloc = DescriptionTextBloc();

  Widget textFormField = MyTextField(
    bloc: _bloc,
  );

  GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        body: RepaintBoundary(
          key: _globalKey,
          child: Container(
            color: Theme.of(context).backgroundColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Stack(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      StageSlider(
                        index: 0,
                      ),
                      StageSlider(
                        index: 1,
                      ),
                      StageSlider(
                        index: 2,
                      ),
                    ],
                  ),
                  DescriptionText(
                    bloc: _bloc,
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              child: Icon(Icons.text_fields),
              backgroundColor: Theme.of(context).accentColor,
              onPressed: () => _openTextField(context),
            ),
            SizedBox(
              height: 10.0,
            ),
            _saveFloatingActionButton(context),
          ],
        ),
      );

  void _openTextField(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: 10,
            top: 10.0,
            right: 10,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 10,
          ),
          child: textFormField,
        ),
      ),
    );
  }

  Future<Uint8List> _capturePng() async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext.findRenderObject();

    if (boundary.debugNeedsPaint) {
      print("Waiting for boundary to be painted.");
      await Future.delayed(const Duration(milliseconds: 20));
      return _capturePng();
    }

    var image = await boundary.toImage();
    var byteData = await image.toByteData(format: ImageByteFormat.png);
    return byteData.buffer.asUint8List();
  }

  Future<void> _saveImage(bytes) async {
    _startLoading();
    ImageSaver _imageSaver = ImageSaver();
    List<Uint8List> bytesList = [bytes];
    final res = await _imageSaver.saveImages(imageBytes: bytesList);
    print(res);
    _displayResult(res);
  }

  Widget _saveFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.save),
      backgroundColor: Theme.of(context).accentColor,
      onPressed: _onSaveFinalImage,
    );
  }

  void _onSaveFinalImage() async {
    if (await allowedStoragePermission()) {
      _saveImage(await _capturePng());
    } else
      Toast.show('Access denied');
  }

  void _startLoading() {
    Toast.show('Saving..');
  }

  void _displayResult(bool success) {
    if (success) {
      Toast.show('Saved');
    } else {
      Toast.show('There was an error saving image!');
    }
  }
}
