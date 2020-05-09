import 'dart:math';
import 'dart:ui';
import 'dart:async';

import 'package:flame/bgm.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_swarm_game/components/corona.dart';
import 'package:flutter_swarm_game/components/game_over_text.dart';
import 'package:flutter_swarm_game/components/instructions_text.dart';
import 'package:flutter_swarm_game/components/mask.dart';
import 'package:flutter_swarm_game/components/health_bar.dart';
import 'package:flutter_swarm_game/components/highscore_text.dart';
import 'package:flutter_swarm_game/components/human.dart';
import 'package:flutter_swarm_game/components/music_button.dart';
import 'package:flutter_swarm_game/spawners/mask_spawner.dart';
import 'package:flutter_swarm_game/components/score_text.dart';
import 'package:flutter_swarm_game/components/start_text.dart';
import 'package:flutter_swarm_game/components/title_text.dart';
import 'package:flutter_swarm_game/spawners/corona_spawner.dart';
import 'package:flutter_swarm_game/state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameController extends Game {
  final SharedPreferences storage;
  Random rand;
  Size screenSize;
  double tileSize;
  Human human;
  CoronaSpawner coronaSpawner;
  MaskSpawner maskSpawner;
  List<Corona> enemies;
  List<Mask> aids;
  HealthBar healthBar;
  int score;
  ScoreText scoreText;
  State state;
  HighscoreText highscoreText;
  InstructionsText instructionsText;
  TitleText titleText;
  StartText startText;
  GameOverText gameOverText;
  
  MusicButton musicButton;
  Bgm backgroundMusic = Bgm();

  GameController(this.storage) {
    initialize();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());
    state = State.menu;
    rand = Random();
    human = Human(this);
    enemies = List<Corona>();
    aids = List<Mask>();
    coronaSpawner = CoronaSpawner(this);
    maskSpawner = MaskSpawner(this);
    healthBar = HealthBar(this);
    score = 0;
    scoreText = ScoreText(this);
    highscoreText = HighscoreText(this);
    instructionsText = InstructionsText(this);
    titleText = TitleText(this);
    gameOverText = GameOverText(this);
    startText = StartText(this);
    musicButton = MusicButton(this);

    backgroundMusic.play('background.mp3');
  }

  void render(Canvas c) {
    Rect background = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
    Paint backgroundPaint = Paint()..color = Color(0xF55AAAFF);
    c.drawRect(background, backgroundPaint);

    if (state == State.menu) {
      titleText.render(c);
      highscoreText.render(c);
      human.render(c);
      startText.render(c);
      instructionsText.render(c);
      drawGrassBottom(c);
    } else if (state == State.playing) {
      drawGrassMiddle(c);
      enemies.forEach((Corona corona) => corona.render(c));
      aids.forEach((Mask mask) => mask.render(c));
      scoreText.render(c);
      healthBar.render(c);
      human.render(c);
    } else if (state == State.gameover) {
      gameOverText.render(c);
      drawBlob(c);
    }
    musicButton.render(c);
  }

  void update(double t) {
    if (state == State.menu) {
      titleText.update(t);
      startText.update(t);
      highscoreText.update(t);
      instructionsText.update(t);
    } else if (state == State.playing) {
      coronaSpawner.update(t);
      maskSpawner.update(t);
      enemies.forEach((Corona corona) => corona.update(t));
      enemies.removeWhere((Corona corona) => corona.isDead);
      aids.forEach((Mask mask) => mask.update(t));
      aids.removeWhere((Mask mask) => mask.isUsed);
      human.update(t);
      scoreText.update(t);
      healthBar.update(t);
    } else if (state == State.gameover) {
        gameOverText.update(t);
      }
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 10;
  }

  void onTapDown(TapDownDetails d) {
        
    if (musicButton.rect.contains(d.globalPosition)) {
      musicButton.onTapDown();
    }else if (state == State.menu) {
      state = State.playing;
    } else if (state == State.playing) {
      enemies.forEach((Corona corona) {
        if (corona.coronaRect.contains(d.globalPosition)) {
          corona.onTapDown();
        }
      });
      aids.forEach((Mask mask) {
        if (mask.maskRect.contains(d.globalPosition)) {
          mask.onTapDown();
        }
      });
    } else if (state == State.gameover) {
      initialize();
    }
  }
  
  void gameOver() async{
    resize(await Flame.util.initialDimensions());
    state = State.gameover;
    backgroundMusic.stop();
    backgroundMusic.clearAll();
    // reset to main menu after 3 seconds
    Timer(Duration(seconds: 3), () {
     initialize();
    });
  }

  // spawn corona so that they can come from every direction
  void spawnCorona() {
    double x, y;
    switch (rand.nextInt(4)) {
      case 0:
        // Top
        x = rand.nextDouble() * screenSize.width;
        y = -tileSize * 2.5;
        break;
      case 1:
        // Right
        x = screenSize.width + tileSize * 2.5;
        y = rand.nextDouble() * screenSize.height;
        break;
      case 2:
        // Bottom
        x = rand.nextDouble() * screenSize.width;
        y = screenSize.height + tileSize * 2.5;
        break;
      case 3:
        // Left
        x = -tileSize * 2.5;
        y = rand.nextDouble() * screenSize.height;
        break;
    }
    enemies.add(Corona(this, x, y));
  }

   // spawn masks so that they can come from every direction
  void spawnMask() {
    double x, y;
    switch (rand.nextInt(4)) {
      case 0:
        // Top
        x = rand.nextDouble() * screenSize.width;
        y = -tileSize * 2.5;
        break;
      case 1:
        // Right
        x = screenSize.width + tileSize * 2.5;
        y = rand.nextDouble() * screenSize.height;
        break;
      case 2:
        // Bottom
        x = rand.nextDouble() * screenSize.width;
        y = screenSize.height + tileSize * 2.5;
        break;
      case 3:
        // Left
        x = -tileSize * 2.5;
        y = rand.nextDouble() * screenSize.height;
        break;
    }
    aids.add(Mask(this, x, y));
  }

  void drawGrassBottom(Canvas c) {
    // draw some grass on the bottom of the screen
    var paint = Paint();
    paint.color = Color(0xFF00CC00);
    paint.style = PaintingStyle.fill;
    var path = Path();
    path.moveTo(0, screenSize.height * 0.9167);
    path.quadraticBezierTo(screenSize.width * 0.25, screenSize.height * 0.875,
        screenSize.width * 0.5, screenSize.height * 0.9167);
    path.quadraticBezierTo(screenSize.width * 0.75, screenSize.height * 0.9584,
        screenSize.width * 1.0, screenSize.height * 0.9167);
    path.lineTo(screenSize.width, screenSize.height);
    path.lineTo(0, screenSize.height);

    c.drawPath(path, paint);
  }

  void drawGrassMiddle(Canvas c) {
    // draw some grass on the bottom of the screen
    var paint = Paint();
    paint.color = Color(0xFF00CC00);
    paint.style = PaintingStyle.fill;
    var path = Path();
    path.moveTo(0, screenSize.height/1.5 * 0.95);
    path.quadraticBezierTo(screenSize.width * 0.3, screenSize.height/1.6 * 0.88,
        screenSize.width * 0.6, screenSize.height/1.6 * 0.93);
    path.quadraticBezierTo(screenSize.width * 0.8, screenSize.height/1.6 * 0.96,
        screenSize.width, screenSize.height/1.5 * 0.9);
    path.lineTo(screenSize.width, screenSize.height);
    path.lineTo(0, screenSize.height);
    c.drawPath(path, paint);
  }

  void drawBlob(Canvas c) {
    Path path = Path();
    Paint paint = Paint();

    path.lineTo(0, screenSize.height/6 *0.75);
    path.quadraticBezierTo(screenSize.width* 0.10, screenSize.height/6*0.70,   screenSize.width*0.17, screenSize.height/6*0.90);
    path.quadraticBezierTo(screenSize.width*0.20, screenSize.height/6, screenSize.width*0.25, screenSize.height/6*0.90);
    path.quadraticBezierTo(screenSize.width*0.40, screenSize.height/6*0.40, screenSize.width*0.50, screenSize.height/6*0.70);
    path.quadraticBezierTo(screenSize.width*0.60, screenSize.height/6*0.85, screenSize.width*0.65, screenSize.height/6*0.65);
    path.quadraticBezierTo(screenSize.width*0.70, screenSize.height/6*0.90, screenSize.width, 0);
    path.close();

    paint.color = Color(0xFF770000);
    c.drawPath(path, paint);

    path = Path();
    path.lineTo(0, screenSize.height/6*0.50);
    path.quadraticBezierTo(screenSize.width*0.10, screenSize.height/6*0.80, screenSize.width*0.15, screenSize.height/6*0.60);
    path.quadraticBezierTo(screenSize.width*0.20, screenSize.height/6*0.45, screenSize.width*0.27, screenSize.height/6*0.60);
    path.quadraticBezierTo(screenSize.width*0.45, screenSize.height/6, screenSize.width*0.50, screenSize.height/6*0.80);
    path.quadraticBezierTo(screenSize.width*0.55, screenSize.height/6*0.45, screenSize.width*0.75, screenSize.height/6*0.75);
    path.quadraticBezierTo(screenSize.width*0.85, screenSize.height/6*0.99, screenSize.width, screenSize.height/6*0.60);
    path.lineTo(screenSize.width, 0);
    path.close();

    paint.color = Color(0xFFAA0000);
    c.drawPath(path, paint);

    path =Path();
    path.lineTo(0, screenSize.height/7*0.75);
    path.quadraticBezierTo(screenSize.width*0.10, screenSize.height/6*0.45, screenSize.width*0.22, screenSize.height/6*0.70);
    path.quadraticBezierTo(screenSize.width*0.30, screenSize.height/6*0.90, screenSize.width*0.40, screenSize.height/6*0.75);
    path.quadraticBezierTo(screenSize.width*0.52, screenSize.height/6*0.50, screenSize.width*0.65, screenSize.height/6*0.70);
    path.quadraticBezierTo(screenSize.width*0.75, screenSize.height/6*0.85, screenSize.width, screenSize.height/6*0.60);
    path.lineTo(screenSize.width, 0);
    path.close();

    paint.color = Color(0xFFFF0000);
    c.drawPath(path, paint);
  }
}
