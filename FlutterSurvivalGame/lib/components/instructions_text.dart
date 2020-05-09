import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_swarm_game/game_controller.dart';

class InstructionsText {
  final GameController gameController;
  TextPainter painter;
  Offset position;

  InstructionsText(this.gameController) {
    painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    position = Offset.zero;
  }

  void render(Canvas c) {
    painter.paint(c, position);
  }

  void update(double t) {
    painter.text = TextSpan(
      text: '''Instructions:
1. Don't let the virus get to you
2. Use masks to restore health''',
      style: TextStyle(
        color: Colors.black,
        fontSize: 20.0,
        
      ),
    );
    painter.layout();

    position = Offset(
      (gameController.screenSize.width / 2) - (painter.width / 2),
      (gameController.screenSize.height * 0.82) - (painter.height / 2),
    );
  }
}
