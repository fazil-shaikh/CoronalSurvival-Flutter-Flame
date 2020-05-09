import 'dart:math';
import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swarm_game/game_controller.dart';

class Mask {
  final GameController gameController;
  double speed;
  int health;
  Rect maskRect;
  bool isUsed = false;
  Random r;
  Sprite maskSprite;

  Mask(this.gameController, double x, double y) {
    r = new Random();
    health = 50;

    // randomize the mask image each spawn 
    if((r.nextInt(2) + 1) == 1)
      maskSprite = Sprite('n95-mask.png');
    else
      maskSprite = Sprite('surgical-mask.png');

    // randomize the speed of the mask
    speed = gameController.tileSize * (r.nextInt(2) + 1);
    maskRect = Rect.fromLTWH(
      x,
      y,
      gameController.tileSize * 1.2,
      gameController.tileSize * 1.2,
    );
  }

  void render(Canvas c) {
      maskSprite.renderRect(c, maskRect);
  }

  void update(double t) {
    if (!isUsed) {
      double stepDistance = speed * t;
      Offset toHuman =
          gameController.human.humanRect.center - maskRect.center;
      if (stepDistance <= toHuman.distance - gameController.tileSize * 1.25) {
        Offset stepToHuman =
            Offset.fromDirection(toHuman.direction, stepDistance);
        maskRect = maskRect.shift(stepToHuman);
      } else {
        aid();
      }
    }
  }

 // reduce the human's health when in range
  void aid() {
    if (!gameController.human.isDead) {
      if (gameController.human.currentHealth+50 > gameController.human.maxHealth){
        gameController.human.currentHealth = gameController.human.maxHealth;
      }
      else {
         gameController.human.currentHealth += 50;
      }
      isUsed = true;
    }
  }

  void onTapDown() {
    if (!isUsed) {
      aid();
      health -= 50;
      if (health <= 0) {
        isUsed = true;
      }
    }
  }
}
