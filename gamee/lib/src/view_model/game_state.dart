import '../model/obstacle.dart';
import '../model/game_mode.dart';
import '../model/bullet.dart';

class GameState {
  final bool isRunning;
  final bool isGameOver;
  final double playerX;
  final List<Obstacle> obstacles;
  final List<Bullet> bullets;
  final int coins;
  final int level;
  final GameMode mode;

  const GameState({
    this.isRunning = false,
    this.isGameOver = false,
    this.playerX = 0.5,
    this.obstacles = const [],
    this.bullets = const [],
    this.coins = 0,
    this.level = 1,
    this.mode = GameMode.arcade,
  });

  GameState copyWith({
    bool? isRunning,
    bool? isGameOver,
    double? playerX,
    List<Obstacle>? obstacles,
    List<Bullet>? bullets,
    int? coins,
    int? level,
    GameMode? mode,
  }) {
    return GameState(
      isRunning: isRunning ?? this.isRunning,
      isGameOver: isGameOver ?? this.isGameOver,
      playerX: playerX ?? this.playerX,
      obstacles: obstacles ?? this.obstacles,
      bullets: bullets ?? this.bullets,
      coins: coins ?? this.coins,
      level: level ?? this.level,
      mode: mode ?? this.mode,
    );
  }
}
