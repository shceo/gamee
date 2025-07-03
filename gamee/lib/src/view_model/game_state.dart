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
  final Set<int> purchasedUpgradeIds;
  final int level;
  final GameMode mode;

  const GameState({
    this.isRunning = false,
    this.isGameOver = false,
    this.playerX = 0.5,
    this.obstacles = const [],
    this.bullets = const [],
    this.coinBalance = 0,
    this.purchasedSkinIds = const {},
    this.purchasedUpgradeIds = const {},
    this.level = 1,
    this.mode = GameMode.arcade,
  });

  GameState copyWith({
    bool? isRunning,
    bool? isGameOver,
    double? playerX,
    List<Obstacle>? obstacles,
    List<Bullet>? bullets,
    int? coinBalance,
    Set<int>? purchasedSkinIds,
    Set<int>? purchasedUpgradeIds,
    int? level,
    GameMode? mode,
  }) {
    return GameState(
      isRunning: isRunning ?? this.isRunning,
      isGameOver: isGameOver ?? this.isGameOver,
      playerX: playerX ?? this.playerX,
      obstacles: obstacles ?? this.obstacles,
      bullets: bullets ?? this.bullets,
      coinBalance: coinBalance ?? this.coinBalance,
      purchasedSkinIds: purchasedSkinIds ?? this.purchasedSkinIds,
      purchasedUpgradeIds:
          purchasedUpgradeIds ?? this.purchasedUpgradeIds,
      level: level ?? this.level,
      mode: mode ?? this.mode,
    );
  }
}
