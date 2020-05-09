
import 'package:flame/util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swarm_game/game_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flame/flame.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Util flameUtil = Util();
  await flameUtil.fullScreen();
  await flameUtil.setOrientation(DeviceOrientation.portraitUp);

  SharedPreferences storage = await SharedPreferences.getInstance();
  GameController gameController = GameController(storage);
  runApp(gameController.widget);

  TapGestureRecognizer tapper = TapGestureRecognizer();
  tapper.onTapDown = gameController.onTapDown;
  flameUtil.addGestureRecognizer(tapper);

  Flame.bgm.initialize();

  // load in all the images from assets
  Flame.images.loadAll(<String>[
  'corona.png',
  'n95-mask.png',
  'surgical-mask.png',
  'icon-music-enabled.png',
  'icon-music-disabled.png'
]);

  Flame.audio.loadAll(<String> [
    'astronomical.mp3',
    'background.mp3'
  ]);
}