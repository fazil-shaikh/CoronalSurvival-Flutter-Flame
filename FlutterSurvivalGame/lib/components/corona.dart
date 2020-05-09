import 'dart:math';
import 'dart:ui';
import 'package:flame/sprite.dart';

import 'package:flutter/material.dart';
import 'package:flutter_swarm_game/game_controller.dart';


class Corona {
  final GameController gameController;
  int health;
  int damage;
  double speed;
  Rect coronaRect;
  bool isDead = false;
  double i, j;
  Random r;
  Sprite coronaSprite;

  Corona(this.gameController, double x, double y) {
    coronaSprite = Sprite('corona.png');
    r = new Random();
    health = 1;
    damage = 1;
    i = x; 
    j = y;
    
    // randomize the speed of the virus
    speed = gameController.tileSize * (r.nextDouble() * (2.5 - 0.7) + 0.7);
    coronaRect = Rect.fromLTWH(
      x,
      y,
      gameController.tileSize * 1.2,
      gameController.tileSize * 1.2,
    );
  }

  // draws the image sprite for corona
  void render(Canvas c) {
    coronaSprite.renderRect(c, coronaRect);
  }

  void update(double t) {
    if (!isDead) {
      double stepDistance = speed * t;
      Offset toHuman =
          gameController.human.humanRect.center - coronaRect.center;
      if (stepDistance <= toHuman.distance - gameController.tileSize * 1.25) {
        Offset stepToHuman =
            Offset.fromDirection(toHuman.direction, stepDistance);
        coronaRect = coronaRect.shift(stepToHuman);
      } else {
        attack();
      }
    }
  }

 // reduce the human's health when in range
  void attack() {
    if (!gameController.human.isDead) {
      gameController.human.currentHealth -= damage;
    }
  }

  void onTapDown() {
    if (!isDead) {
      health--;
      if (health <= 0) {
        isDead = true;
        gameController.score++;
        if (gameController.score > (gameController.storage.getInt('highscore') ?? 0)) {
          gameController.storage.setInt('highscore', gameController.score);
        }
      }
    }
  }
}
