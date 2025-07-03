import '../model/obstacle.dart';
import '../model/game_mode.dart';
import '../model/bullet.dart';

class GameState {
  final bool isRunning;
  final bool isGameOver;
  final double playerX;
  final List<Obstacle> obstacles;
  final List<Bullet> bullets;
  final int coinBalance;
  final Set<int> purchasedSkinIds;
  final int attackSpeedLevel;
  final int damageLevel;
  final int level;
  final GameMode mode;
  final bool vibrationEnabled;

  const GameState({
    this.isRunning = false,
    this.isGameOver = false,
    this.playerX = 0.5,
    this.obstacles = const [],
    this.bullets = const [],
    this.coinBalance = 0,
    this.purchasedSkinIds = const {},
    this.attackSpeedLevel = 0,
    this.damageLevel = 0,
    this.level = 1,
    this.mode = GameMode.arcade,
    this.vibrationEnabled = true,
  });

  GameState copyWith({
    bool? isRunning,
    bool? isGameOver,
    double? playerX,
    List<Obstacle>? obstacles,
    List<Bullet>? bullets,
    int? coinBalance,
    Set<int>? purchasedSkinIds,
    int? attackSpeedLevel,
    int? damageLevel,
    int? level,
    GameMode? mode,
    bool? vibrationEnabled,
  }) {
    return GameState(
      isRunning: isRunning ?? this.isRunning,
      isGameOver: isGameOver ?? this.isGameOver,
      playerX: playerX ?? this.playerX,
      obstacles: obstacles ?? this.obstacles,
      bullets: bullets ?? this.bullets,
      coinBalance: coinBalance ?? this.coinBalance,
      purchasedSkinIds: purchasedSkinIds ?? this.purchasedSkinIds,
      attackSpeedLevel: attackSpeedLevel ?? this.attackSpeedLevel,
      damageLevel: damageLevel ?? this.damageLevel,
      level: level ?? this.level,
      mode: mode ?? this.mode,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
    );
  }
}
