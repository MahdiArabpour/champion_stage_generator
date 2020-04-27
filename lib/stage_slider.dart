import 'package:champion_stage_generator/stage_height_bloc.dart';
import 'package:flutter/material.dart';

class StageSlider extends StatefulWidget {
  final index;

  const StageSlider({Key key, this.index}) : super(key: key);

  @override
  _StageSliderState createState() => _StageSliderState();
}

class _StageSliderState extends State<StageSlider> {
  final _bloc = StageHeightBloc();

  int _index;

  double _startPosition = 0.0;
  double _currentHeight = 0.0;
  double _previousPosition = 0.0;
  double _singleStageWidth;
  double _imagePlaceHolderPadding;
  double _defaultHeight;
  double _maxHeight;
  double _minHeight;
  double _stageHeight;

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
    _defaultHeight = 0.0;
    _didRebuild = true;
    _maxHeight =
        _mediaQuerySize.height - _mediaQuery.padding.top - _singleStageWidth;
    _minHeight = _mediaQuerySize.height * 0.1;
    if (_index == 0)
      _defaultHeight = _maxHeight * 0.60;
    else if (_index == 1)
      _defaultHeight = _maxHeight * 0.75;
    else if (_index == 2) _defaultHeight = _maxHeight * 0.45;
    return GestureDetector(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(_imagePlaceHolderPadding),
            height: _singleStageWidth,
            width: _singleStageWidth,
            child: Container(
              color: Colors.amber,
            ),
          ),
          Container(
            color: Colors.white30,
            width: _singleStageWidth,
            child: StreamBuilder(
                stream: _bloc.heightStream,
                builder: (context, snapshot) {
                  if (snapshot.data == null)
                    _stageHeight = _defaultHeight;
                  else if (snapshot.data >= _maxHeight)
                    _stageHeight = _maxHeight;
                  else
                    _stageHeight = snapshot.data;

                  if (_didRebuild) {
                    _previousPosition = _stageHeight;
                    _bloc.heightSink.add(_stageHeight);
                  }

                  _didRebuild = false;
                  return Container(
                    color: Colors.blue[900],
                    height: _stageHeight,
                  );
                }),
          ),
        ],
      ),
      onVerticalDragStart: _onDragStart,
      onVerticalDragUpdate: _onDragUpdate,
      onVerticalDragEnd: _onDragEnd,
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
    _bloc.heightSink.add(_currentHeight);
  }

  void _onDragEnd(DragEndDetails details) => _previousPosition = _currentHeight;

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
}
