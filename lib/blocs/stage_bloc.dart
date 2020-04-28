import 'dart:async';

import '../models/stage.dart';

class StageBloc {
  final stageStateController = StreamController<Stage>();

  StreamSink<Stage> get stageSink => stageStateController.sink;

  Stream<Stage> get stageStream => stageStateController.stream;

  void close() {
    stageStateController.close();
  }
}
