import 'package:flutter/material.dart';

import '../blocs/description_text_bloc.dart';
import '../models/description_text_data.dart';

class MyTextField extends StatefulWidget {
  final DescriptionTextBloc bloc;

  const MyTextField({Key key, @required this.bloc}) : super(key: key);

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

String _text = '';

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) => TextField(
        decoration: InputDecoration(
          labelText: 'Description',
        ),
        controller: TextEditingController()..text = _text,
        textAlign: TextAlign.end,
        onChanged: (String value) {
          _text = value;
          final textData = DescriptionTextData(text: value);
          widget.bloc.descriptionTextSink.add(textData);
        },
      );
}
