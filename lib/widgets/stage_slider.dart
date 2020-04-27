import 'package:champion_stage_generator/models/stage.dart';
import 'package:champion_stage_generator/blocs/stage_bloc.dart';
import 'package:champion_stage_generator/widgets/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class StageSlider extends StatefulWidget {
  final index;

  const StageSlider({Key key, this.index}) : super(key: key);

  @override
  _StageSliderState createState() => _StageSliderState();
}

class _StageSliderState extends State<StageSlider> {
  final _bloc = StageBloc();

  int _index;

  double _startPosition = 0.0;
  double _currentHeight = 0.0;
  double _previousPosition = 0.0;
  double _singleStageWidth;
  double _imagePlaceHolderPadding;
  Stage _defaultStage;
  double _maxHeight;
  double _minHeight;
  Stage _stage;

  MediaQueryData _mediaQuery;
  Size _mediaQuerySize;

  bool _didRebuild;

  @override
  Widget build(BuildContext context) {
    _mediaQuery = MediaQuery.of(context);
    _mediaQuerySize = _mediaQuery.size;
    _singleStageWidth = _mediaQuerySize.width / 3 - 20;
    _imagePlaceHolderPadding = _singleStageWidth * 0.1;
    _index = widget.index;
    _didRebuild = true;
    _maxHeight =
        _mediaQuerySize.height - _mediaQuery.padding.top - _singleStageWidth;
    _minHeight = _mediaQuerySize.height * 0.05;
    if (_index == 0)
      _defaultStage = Stage(
        height: _maxHeight * 0.60,
      );
    else if (_index == 1)
      _defaultStage = Stage(height: _maxHeight * 0.75);
    else if (_index == 2) _defaultStage = Stage(height: _maxHeight * 0.45);
    return GestureDetector(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          MyImagePicker(
            width: _singleStageWidth,
            padding: _imagePlaceHolderPadding,
          ),
          Container(
            width: _singleStageWidth,
            child: StreamBuilder(
                stream: _bloc.stageStream,
                builder: (context, snapshot) {
                  if (snapshot.data == null)
                    _stage = _defaultStage;
                  else if (snapshot.data.height >= _maxHeight)
                    _stage =
                        Stage(height: _maxHeight, color: snapshot.data.color);
                  else
                    _stage = snapshot.data;

                  if (_didRebuild) _previousPosition = _stage.height;

                  _didRebuild = false;
                  return Container(
                    decoration: BoxDecoration(
                        color: _stage.color,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          topRight: Radius.circular(5.0),
                        )),
                    height: _stage.height,
                  );
                }),
          ),
        ],
      ),
      onVerticalDragStart: _onDragStart,
      onVerticalDragUpdate: _onDragUpdate,
      onVerticalDragEnd: _onDragEnd,
      onDoubleTap: _onDoubleTap,
    );
  }

  void _onDragStart(DragStartDetails startDetails) {
    final localPosition = startDetails.localPosition;
    _startPosition = _mediaQuerySize.height - localPosition.dy;
  }

  void _onDragUpdate(DragUpdateDetails updateDetails) {
    final localPosition = updateDetails.localPosition;
    final height = _mediaQuerySize.height - localPosition.dy;
    _currentHeight = (_previousPosition - _startPosition) + height;
    if (_currentHeight >= _maxHeight)
      _currentHeight = _maxHeight;
    else if (_currentHeight <= _minHeight) _currentHeight = _minHeight;
    _bloc.stageSink.add(Stage(height: _currentHeight, color: currentColor));
  }

  void _onDragEnd(DragEndDetails details) => _previousPosition = _currentHeight;

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  Color currentColor = Colors.blue;

  void changeColor(Color color) {
    currentColor = color;
    _stage.color = currentColor;
    _bloc.stageSink.add(_stage);
  }

  void _onDoubleTap() {
    showDialog(
      context: context,
      child: AlertDialog(
        title: const Text('Pick a color!'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: currentColor,
            onColorChanged: changeColor,
            showLabel: true,
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text('Got it'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

}
