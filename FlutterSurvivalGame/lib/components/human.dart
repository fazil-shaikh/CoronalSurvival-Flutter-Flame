
import 'package:flutter/material.dart';
import 'package:flutter_swarm_game/game_controller.dart';

class Human {
  final GameController gameController;
  int maxHealth;
  int currentHealth;
  Rect humanRect;
  bool isDead = false;
  double x;
  double y;

  Human(this.gameController) {
    maxHealth = currentHealth = 300;
    final size = 100.0;
    this.x = gameController.screenSize.width/2 - gameController.tileSize;
    this.y = gameController.screenSize.height/2 - gameController.tileSize;
    humanRect = Rect.fromLTWH(
      x-5,
      y,
      size,
      size,
    );
  }

  void render(Canvas c) {
    final icon = Icons.directions_walk;
    TextPainter textPainter = TextPainter(textDirection: TextDirection.rtl);
    textPainter.text = TextSpan(text: String.fromCharCode(icon.codePoint),
            style: TextStyle(fontSize: 100.0,fontFamily: icon.fontFamily, color: Colors.black45));
    textPainter.layout();
    textPainter.paint(c, Offset(x-5, y));
    }

  void update(double t) {
    if (!isDead && currentHealth <= 0) {
      isDead = true;
      gameController.gameOver();
    }
  }
}
