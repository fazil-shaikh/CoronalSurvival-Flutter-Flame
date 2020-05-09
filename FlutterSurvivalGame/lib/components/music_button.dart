import 'dart:ui';
import 'package:flutter_swarm_game/game_controller.dart';
import 'package:flame/sprite.dart';

class MusicButton {
  final GameController gameController;
  Rect rect;
  Sprite enabledSprite;
  Sprite disabledSprite;
  bool isEnabled = true;

  MusicButton(this.gameController) {
    enabledSprite = Sprite('icon-music-enabled.png');
    disabledSprite = Sprite('icon-music-disabled.png');

    rect = Rect.fromLTWH(
      gameController.tileSize * 0.25,
      gameController.tileSize * 0.25,
      gameController.tileSize,
      gameController.tileSize,
    );
  }

  // switches between the on and off music button
  void render(Canvas c) {
    if (isEnabled) {
      c.drawOval(rect, new Paint()..color = new Color(0xFFFFFFF));
      enabledSprite.renderRect(c, rect);
    } else {
      c.drawOval(rect, new Paint()..color = new Color(0xFF000FF));
      disabledSprite.renderRect(c, rect);
    }
  }

  void onTapDown() {
    if (isEnabled) {
      isEnabled = false;
      gameController.backgroundMusic.pause();
    } else {
      isEnabled = true;
      gameController.backgroundMusic.resume();
    }
  }
}