import 'package:flutter_swarm_game/components/mask.dart';
import 'package:flutter_swarm_game/game_controller.dart';

class MaskSpawner {
  final GameController gameController;
  final int maxMasks = 1;
  int currentInterval;
  int nextSpawn;

  MaskSpawner(this.gameController) {
    initialize();
  }

  void initialize() {
    removeAllMasks();
  }

  void removeAllMasks() {
    gameController.aids.forEach((Mask mask) => mask.isUsed = true);
  }
  
  // spawn one mask every five points
  void update(double t) {
    int currScore = gameController.score;
    if (gameController.aids.length < maxMasks && currScore % 5 == 0 && currScore != 0) {
      gameController.spawnMask();
    }
  }
}