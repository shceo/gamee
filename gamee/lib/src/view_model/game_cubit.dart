import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/game_mode.dart';
import '../model/obstacle.dart';
import '../model/bullet.dart';
import 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(const GameState());

  Timer? _ticker;
  Timer? _shootTicker;
  bool _shooting = false;
  final Random _random = Random();
  int _idCounter = 0;

  static const Map<int, int> _skinPrices = {
    1: 100,
    2: 200,
  };

  static const Map<int, int> _upgradeBasePrices = {
    1: 20,
    2: 20,
  };

  int get bulletDamage => 1 + state.damageLevel;
  double get shootInterval => 1.0 / (1 + state.attackSpeedLevel * 0.1);

  int upgradePrice(int id) {
    final base = _upgradeBasePrices[id] ?? 0;
    final level = id == 1 ? state.attackSpeedLevel : state.damageLevel;
    return base + level * 10;
  }

  Future<void> loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final coins = prefs.getInt('coins') ?? 0;
    final skins = prefs.getStringList('skins')?.map(int.parse).toSet() ?? {};
    final speed = prefs.getInt('speed') ?? 0;
    final damage = prefs.getInt('damage') ?? 0;
    emit(
      state.copyWith(
        coinBalance: coins,
        purchasedSkinIds: skins,
        attackSpeedLevel: speed,
        damageLevel: damage,
      ),
    );
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('coins', state.coinBalance);
    await prefs.setStringList(
      'skins',
      state.purchasedSkinIds.map((e) => e.toString()).toList(),
    );
    await prefs.setInt('speed', state.attackSpeedLevel);
    await prefs.setInt('damage', state.damageLevel);
  }

  void startGame(GameMode mode) {
    _ticker?.cancel();
    _shootTicker?.cancel();
    _shooting = false;
    emit(GameState(mode: mode, isRunning: true, playerX: 0.5));
    _ticker = Timer.periodic(const Duration(milliseconds: 16), _onTick);
  }

  void startShooting() {
    if (_shooting) return;
    _shooting = true;
    _spawnBullet();
    _shootTicker = Timer.periodic(
      Duration(milliseconds: (shootInterval * 1000).toInt()),
      (_) => _spawnBullet(),
    );
  }

  void stopShooting() {
    if (!_shooting) return;
    _shooting = false;
    _shootTicker?.cancel();
    _shootTicker = null;
  }

  void _spawnBullet() {
    if (!state.isRunning) return;
    final newBullet = Bullet(id: _idCounter++, x: state.playerX, y: 0.9);
    emit(state.copyWith(bullets: [...state.bullets, newBullet]));
  }

  void _onTick(Timer timer) {
    if (!state.isRunning) return;
    final List<Obstacle> updatedObstacles = [];
    for (final ob in state.obstacles) {
      final newY = ob.y + ob.speed * 0.01;
      if (newY < 1.0) {
        updatedObstacles.add(Obstacle(
          id: ob.id,
          x: ob.x,
          y: newY,
          speed: ob.speed,
          health: ob.health,
        ));
      }
    }

    final List<Bullet> updatedBullets = [];
    for (final bullet in state.bullets) {
      final newY = bullet.y - bullet.speed * 0.01;
      if (newY > 0) {
        updatedBullets.add(Bullet(id: bullet.id, x: bullet.x, y: newY, speed: bullet.speed));
      }
    }

    final List<int> deadObstacles = [];
    final List<int> usedBullets = [];
    for (final bullet in updatedBullets) {
      for (final ob in updatedObstacles) {
        if ((bullet.x - ob.x).abs() < 0.05 && (bullet.y - ob.y).abs() < 0.05) {
          ob.health -= bulletDamage;
          usedBullets.add(bullet.id);
          if (ob.health <= 0) {
            deadObstacles.add(ob.id);
            addCoins(5);
          }
          break;
        }
      }
    }

    updatedBullets.removeWhere((b) => usedBullets.contains(b.id));
    updatedObstacles.removeWhere((o) => deadObstacles.contains(o.id));

    final spawnChance = 0.02 + (state.level - 1) * 0.005;
    if (_random.nextDouble() < spawnChance) {
      final health = state.level;
      updatedObstacles.add(Obstacle.random(_idCounter++, health));
    }

    int newLevel = state.level;
    if (state.mode == GameMode.endless && timer.tick % 600 == 0) {
      newLevel += 1;
    }

    for (final ob in updatedObstacles) {
      if (ob.y > 0.95 && (ob.x - state.playerX).abs() < 0.05) {
        emit(state.copyWith(isRunning: false, isGameOver: true));
        addCoins(5);
        _ticker?.cancel();
        _shootTicker?.cancel();
        return;
      }
    }

    emit(state.copyWith(
      obstacles: updatedObstacles,
      bullets: updatedBullets,
      level: newLevel,
    ));
  }

  void movePlayer(double dxFraction) {
    final newX = dxFraction.clamp(0.0, 1.0);
    emit(state.copyWith(playerX: newX));
  }

  void restart() {
    emit(state.copyWith(
      isRunning: false,
      isGameOver: false,
      obstacles: [],
      bullets: [],
      playerX: 0.5,
      level: 1,
    ));
  }

  void addCoins(int count) {
    emit(state.copyWith(coinBalance: state.coinBalance + count));
    _saveState();
  }

  void purchaseSkin(int id) {
    final price = _skinPrices[id] ?? 0;
    if (state.coinBalance < price || state.purchasedSkinIds.contains(id)) return;
    emit(
      state.copyWith(
        coinBalance: state.coinBalance - price,
        purchasedSkinIds: {...state.purchasedSkinIds, id},
      ),
    );
    _saveState();
  }

  void purchaseUpgrade(int id) {
    final price = upgradePrice(id);
    if (state.coinBalance < price) {
      return;
    }

    if (id == 1) {
      emit(state.copyWith(
        coinBalance: state.coinBalance - price,
        attackSpeedLevel: state.attackSpeedLevel + 1,
      ));
    } else if (id == 2) {
      emit(state.copyWith(
        coinBalance: state.coinBalance - price,
        damageLevel: state.damageLevel + 1,
      ));
    }
    _saveState();
  }

  Future<void> resetProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    emit(const GameState());
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    _shootTicker?.cancel();
    return super.close();
  }
}
