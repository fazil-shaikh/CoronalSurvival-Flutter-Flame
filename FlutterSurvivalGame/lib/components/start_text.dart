import 'package:flutter/material.dart';
import 'package:flutter_swarm_game/game_controller.dart';

class StartText {
  final GameController gameController;
  TextPainter painter;
  Offset position;

  StartText(this.gameController) {
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
      text: 'Tap to Play',
      style: TextStyle(
        color: Colors.black,
        fontSize: 30.0,
        shadows: [
        Shadow( // bottomLeft
          offset: Offset(-1.5, -1.5),
          color: Colors.white
        ),
      ]
      ),
    );
    painter.layout();

    position = Offset(
      (gameController.screenSize.width / 2) - (painter.width / 2),
      (gameController.screenSize.height * 0.7) - (painter.height / 2),
    );
  }
}
