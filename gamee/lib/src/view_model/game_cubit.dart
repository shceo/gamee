import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/game_mode.dart';
import '../model/obstacle.dart';
import 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(const GameState());

  Timer? _ticker;
  final Random _random = Random();
  int _idCounter = 0;

  Future<void> loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final coins = prefs.getInt('coins') ?? 0;
    emit(state.copyWith(coins: coins));
  }

  Future<void> _saveCoins() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('coins', state.coins);
  }

  void startGame(GameMode mode) {
    _ticker?.cancel();
    emit(GameState(mode: mode, isRunning: true, playerX: 0.5));
    _ticker = Timer.periodic(const Duration(milliseconds: 16), _onTick);
  }

  void _onTick(Timer timer) {
    if (!state.isRunning) return;
    final List<Obstacle> updated = [];
    for (final ob in state.obstacles) {
      final newY = ob.y + ob.speed * 0.01;
      if (newY < 1.0) {
        updated.add(Obstacle(id: ob.id, x: ob.x, y: newY, speed: ob.speed));
      } else {
        // missed obstacle, maybe increase coins etc
      }
    }
    // spawn new obstacle occasionally
    if (_random.nextDouble() < 0.02) {
      updated.add(Obstacle.random(_idCounter++));
    }
    // check collision
    for (final ob in updated) {
      if (ob.y > 0.9 && (ob.x - state.playerX).abs() < 0.1) {
        emit(state.copyWith(isRunning: false, isGameOver: true));
        _ticker?.cancel();
        return;
      }
    }
    emit(state.copyWith(obstacles: updated));
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
      playerX: 0.5,
    ));
  }

  void addCoins(int count) {
    emit(state.copyWith(coins: state.coins + count));
    _saveCoins();
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    return super.close();
  }
}
