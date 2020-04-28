import 'package:flutter/material.dart';

import './blocs/description_text_bloc.dart';
import './models/description_text_data.dart';
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

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        body: Padding(
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
            FloatingActionButton(
              child: Icon(Icons.save),
              backgroundColor: Theme.of(context).accentColor,
              onPressed: _onSaveFinalImage,
            )
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

  void _onSaveFinalImage() async {
    if (await allowedStoragePermission()) {
      // TODO
    } else
      Toast.show('Access denied');
  }
}

class MyTextField extends StatefulWidget {
  final DescriptionTextBloc bloc;

  const MyTextField({Key key, @required this.bloc}) : super(key: key);

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

String _text = '';

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    print(_text);
    return TextField(
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
}
