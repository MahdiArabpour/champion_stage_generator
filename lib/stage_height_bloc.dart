import 'dart:async';

class StageHeightBloc{

  final heightStateController = StreamController<double>();

  StreamSink<double> get heightSink => heightStateController.sink;

  Stream<double> get heightStream => heightStateController.stream;

  void close(){
    heightStateController.close();
  }
}
