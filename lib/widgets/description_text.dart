import 'package:champion_stage_generator/blocs/description_text_bloc.dart';
import 'package:flutter/material.dart';

import '../models/description_text_data.dart';

class DescriptionText extends StatefulWidget {
  final DescriptionTextBloc bloc;

  const DescriptionText({Key key, @required this.bloc}) : super(key: key);

  @override
  _DescriptionTextState createState() => _DescriptionTextState();
}

class _DescriptionTextState extends State<DescriptionText> {
  DescriptionTextBloc _bloc;
  final widgetPadding = 8.0;
  final textStyle = TextStyle(
    fontSize: 26,
    color: Colors.white,
  );
  double textHeight;
  double textWidth;
  double containerMaxWidth = 0.0;
  DescriptionTextData _defaultTextData;
  String _text;

  @override
  void initState() {
    _bloc = widget.bloc;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _bloc.descriptionTextStream,
        builder: (context, snapshot) {
          _defaultTextData = DescriptionTextData(
            top: 10,
            text: '',
          );
          DescriptionTextData textData;
          textData = snapshot.data == null ? _defaultTextData : snapshot.data;

          final textSize = _textSize(textData.text, textStyle);
          double containerHorizontalPadding = 15;
          double containerVerticalPadding = 5;
          textHeight = textSize.height + containerVerticalPadding * 2;
          textWidth = textSize.width + containerHorizontalPadding * 2;
          containerMaxWidth = MediaQuery.of(context).size.width * 0.85;
          _text = textData.text;
          return textData.text == ''
              ? Container()
              : Positioned(
                  top: textData.top,
                  left: textData.left,
                  child: GestureDetector(
                    child: Container(
                      color: Colors.black54,
                      constraints: BoxConstraints(
                        maxWidth: containerMaxWidth,
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: containerVerticalPadding,
                          horizontal: containerHorizontalPadding),
                      child: Text(
                        textData.text,
                        style: textStyle,
                        softWrap: true,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    onVerticalDragStart: _onVerticalDragStart,
                    onVerticalDragUpdate: _onVerticalDragUpdate,
                  ),
                );
        });
  }

  Offset localPosition;

  void _onVerticalDragStart(DragStartDetails startDetails) =>
      localPosition = startDetails.localPosition;

  void _onVerticalDragUpdate(DragUpdateDetails updateDetails) {
    final mediaQuery = MediaQuery.of(context);
    final globalPosition = updateDetails.globalPosition;
    double top = globalPosition.dy - localPosition.dy;
    double left = globalPosition.dx - localPosition.dx;
    double maxTop = mediaQuery.size.height -
        textHeight -
        mediaQuery.padding.bottom -
        widgetPadding;
    double minTop = mediaQuery.padding.top + widgetPadding;
    double maxLeft = mediaQuery.size.width - textWidth - widgetPadding;
    double minLeft = widgetPadding;
    if (top >= maxTop)
      top = maxTop;
    else if (top <= minTop) top = minTop;
    if (left >= maxLeft)
      left = maxLeft;
    else if (left <= minLeft) left = minLeft;
    _bloc.descriptionTextSink
        .add(DescriptionTextData(left: left, top: top, text: _text));
  }

  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: containerMaxWidth);
    return textPainter.size;
  }
}
