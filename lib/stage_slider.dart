import 'package:flutter/material.dart';

class StageSlider extends StatelessWidget {

  final double height;

  const StageSlider({Key key, @required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final singleStageWidth = MediaQuery.of(context).size.width / 3 - 20;
    return GestureDetector(
      child: Container(
        width: singleStageWidth,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.blue[900],
            height: height,
          ),
        ),
      ),
      onVerticalDragStart: _onDragStart,
      onVerticalDragUpdate: _onDragUpdate,
      onVerticalDragEnd: _onDragEnd,
    );
  }

  void _onDragStart(DragStartDetails startDetails) {}

  void _onDragUpdate(DragUpdateDetails updateDetails) {}

  void _onDragEnd(DragEndDetails endDetails) {}
}
