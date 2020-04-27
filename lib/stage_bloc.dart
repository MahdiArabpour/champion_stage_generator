import 'dart:async';

import 'package:champion_stage_generator/models/stage.dart';

class StageBloc {
  final stageStateController = StreamController<Stage>();

  StreamSink<Stage> get stageSink => stageStateController.sink;

  Stream<Stage> get stageStream => stageStateController.stream;

  void close() {
    stageStateController.close();
  }
}
