import 'dart:async';

import '../models/description_text_data.dart';

class DescriptionTextBloc{
  final _controller = StreamController<DescriptionTextData>.broadcast();

  StreamSink<DescriptionTextData> get descriptionTextSink => _controller.sink;

  Stream<DescriptionTextData> get descriptionTextStream => _controller.stream;

  void close(){
    _controller.close();
  }
}