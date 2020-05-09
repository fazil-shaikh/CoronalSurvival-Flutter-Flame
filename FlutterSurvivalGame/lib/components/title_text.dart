import 'package:flutter/material.dart';
import 'package:flutter_swarm_game/game_controller.dart';

class TitleText {
  final GameController gameController;
  TextPainter painter;
  Offset position;

  TitleText(this.gameController) {
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
      text: 'Corona Survival',
      style: TextStyle(
        color: Colors.red[700],
        fontSize: 50.0,
        fontWeight: FontWeight.bold,
        shadows: [
        Shadow( // bottomLeft
          offset: Offset(-1.5, -1.5),
          color: Colors.white
        ),
        Shadow( // bottomRight
          offset: Offset(1.5, -1.5),
          color: Colors.white
        ),
        Shadow( // topRight
          offset: Offset(1.5, 1.5),
          color: Colors.black
        ),
        Shadow( // topLeft
          offset: Offset(-1.5, 1.5),
          color: Colors.black
        ),
        ]
      ),
    );
    painter.layout();

    position = Offset(
      (gameController.screenSize.width / 2) - (painter.width / 2),
      (gameController.screenSize.height * 0.25) - (painter.height / 2),
    );
  }
}
