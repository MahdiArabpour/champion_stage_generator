import 'package:champion_stage_generator/stage_height_bloc.dart';
import 'package:flutter/material.dart';

class StageSlider extends StatefulWidget {

  final index;

  const StageSlider({Key key, this.index}) : super(key: key);

  @override
  _StageSliderState createState() => _StageSliderState();
}

class _StageSliderState extends State<StageSlider> {
  final bloc = StageHeightBloc();

  @override
  Widget build(BuildContext context) {
    final singleStageWidth = MediaQuery.of(context).size.width / 3 - 20;
    final index = widget.index;
    var height = 0.0;
    if (index == 0) height = MediaQuery.of(context).size.height / 2.5;
    else if (index == 1) height = MediaQuery.of(context).size.height / 2;
    else if (index == 2) height = MediaQuery.of(context).size.height / 3.25;
    return GestureDetector(
      child: Container(
        color: Colors.white30,
        width: singleStageWidth,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: StreamBuilder(
              stream: bloc.heightStream,
              builder: (context, snapshot) => Container(
                    color: Colors.blue[900],
                    height: snapshot.data ?? height,
                  )),
        ),
      ),
      onVerticalDragStart: _onDragStart,
      onVerticalDragUpdate: _onDragUpdate,
      onVerticalDragEnd: _onDragEnd,
    );
  }

  var startPosition = 0.0;
  var currentHeight = 0.0;
  var previousPosition = 150.0;

  void _onDragStart(DragStartDetails startDetails) {
    final localPosition = startDetails.localPosition;
    startPosition = MediaQuery.of(context).size.height - localPosition.dy;
  }

  void _onDragUpdate(DragUpdateDetails updateDetails) {
    final localPosition = updateDetails.localPosition;
    final height = MediaQuery.of(context).size.height - localPosition.dy;
    currentHeight = (previousPosition - startPosition) + height;
    bloc.heightSink.add(currentHeight);
  }

  void _onDragEnd(DragEndDetails details) => previousPosition = currentHeight;

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }
}
