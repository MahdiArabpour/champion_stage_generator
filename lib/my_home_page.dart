import 'package:champion_stage_generator/stage_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              StageSlider(
                height: 175,
              ),
              StageSlider(
                height: 250,
              ),
              StageSlider(
                height: 100,
              ),
            ],
          ),
        ),
      );
}
