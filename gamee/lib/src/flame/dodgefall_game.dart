import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import '../view_model/game_cubit.dart';
import '../model/game_mode.dart';
import 'bullet_component.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class DodgefallGame extends FlameGame
    with HasCollisionDetection, TapDetector, PanDetector {
  DodgefallGame(this.cubit, this.mode);
  @override
  Color backgroundColor() {
    return const Color(0xFFEAECC6);
  }

  final GameCubit cubit;
  final GameMode mode;

  final ValueNotifier<double> elapsed = ValueNotifier(0);
  final ValueNotifier<int> levelNotifier = ValueNotifier(1);
  late final PlayerComponent player;
  late final _Spawner spawner;
  bool _started = false;
  bool _shooting = false;
  double _shootTimer = 0;
  double get _shootInterval => cubit.shootInterval;
  double spawnInterval = 1.0;
  double _levelTimer = 0;
  double _levelDuration = 30;
  int completedLevel = 0;
  int get obstacleHealth =>
      mode == GameMode.arcade
          ? levelNotifier.value
          : 1 + (elapsed.value ~/ 20).toInt();

  void _shoot() {
    final bulletPos = Vector2(player.x, player.y - player.size.y / 2 - 5);
    add(BulletComponent(bulletPos));
  }

  void _startShooting() {
    if (_shooting) return;
    _shooting = true;
    _shoot();
    _shootTimer = 0;
  }

  void _stopShooting() {
    _shooting = false;
    _shootTimer = 0;
  }

  void reset() {
    _started = false;
    _shooting = false;
    _shootTimer = 0;
    elapsed.value = 0;
    levelNotifier.value = 1;
    spawnInterval = 1.0;
    _levelTimer = 0;
    _levelDuration = 30;
    children.whereType<ObstacleComponent>().forEach(
      (e) => e.removeFromParent(),
    );
    children.whereType<BulletComponent>().forEach((b) => b.removeFromParent());
    player.position = Vector2(size.x / 2, size.y - 60);
    pauseEngine();
    overlays
      ..remove('gameover')
      ..remove('levelcomplete')
      ..add('start');
    cubit.restart();
  }

  void continueAfterLevel() {
    overlays.remove('levelcomplete');
    _started = true;
    resumeEngine();
  }

  @override
  Future<void> onLoad() async {
    await images.loadAll(['player.png', 'enemy.png']);
    player = PlayerComponent()..position = Vector2(size.x / 2, size.y - 60);
    add(player);
    spawner = _Spawner()..position = Vector2.zero();
    add(spawner);
    pauseEngine();
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (overlays.isActive('gameover')) {
      super.onTapDown(info);
      return;
    }
    if (!_started) {
      _started = true;
      overlays.remove('start');
      resumeEngine();
      _startShooting();
      super.onTapDown(info);
      return;
    }
    _startShooting();
    super.onTapDown(info);
  }

  @override
  void onTapUp(TapUpInfo info) {
    _stopShooting();
    super.onTapUp(info);
  }

  @override
  void onTapCancel() {
    _stopShooting();
    super.onTapCancel();
  }

  @override
  void onPanStart(DragStartInfo info) {
    if (overlays.isActive('gameover')) {
      super.onPanStart(info);
      return;
    }
    if (!_started) {
      _started = true;
      overlays.remove('start');
      resumeEngine();
    }
    _startShooting();
    super.onPanStart(info);
  }

  @override
  void onPanEnd(DragEndInfo info) {
    _stopShooting();
    super.onPanEnd(info);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    final dx = info.delta.global.x;
    final newX = (player.x + dx).clamp(
      player.size.x / 2,
      size.x - player.size.x / 2,
    );
    player.position = Vector2(newX, player.y);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_started) {
      elapsed.value += dt;
      if (mode == GameMode.arcade) {
        _levelTimer += dt;
        if (_levelTimer >= _levelDuration) {
          _levelTimer = 0;
          _levelDuration += 5;
          completedLevel = levelNotifier.value;
          levelNotifier.value += 1;
          spawnInterval = (spawnInterval * 0.9).clamp(0.3, 10.0);
          _started = false;
          _stopShooting();
          pauseEngine();
          overlays.add('levelcomplete');
        }
      } else {
        if (elapsed.value % 10 < dt) {
          spawnInterval = (spawnInterval * 0.95).clamp(0.2, 10.0);
        }
      }
    }
    if (_shooting) {
      _shootTimer += dt;
      if (_shootTimer >= _shootInterval) {
        _shootTimer = 0;
        _shoot();
      }
    }
  }
}

class PlayerComponent extends SpriteComponent
    with HasGameRef<DodgefallGame>, CollisionCallbacks {
  PlayerComponent() : super(size: Vector2.all(30), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = Sprite(gameRef.images.fromCache('player.png'));
    add(RectangleHitbox());
  }
}

class ObstacleComponent extends SpriteComponent
    with CollisionCallbacks, HasGameRef<DodgefallGame> {
  ObstacleComponent({required double speed, this.health = 1})
      : _initialSpeed = speed,
        super(size: Vector2.all(30), anchor: Anchor.center);

  final double _initialSpeed;
  int health;
  final Vector2 _velocity = Vector2.zero();
  final Random _rand = Random();
  static const double _bounceDamping = 0.8;
  static const double _horizontalFactor = 0.3;

  @override
  Future<void> onLoad() async {
    sprite = Sprite(gameRef.images.fromCache('enemy.png'));
    angle = pi;
    _velocity.setValues(0, _initialSpeed);
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += _velocity * dt;
    if (y >= gameRef.size.y - size.y / 2 && _velocity.y > 0) {
      y = gameRef.size.y - size.y / 2;
      _velocity.y = -_velocity.y * _bounceDamping;
      _velocity.x += (_rand.nextDouble() * 2 - 1) *
          _initialSpeed * _horizontalFactor;
    } else if (y <= gameRef.size.y / 2 && _velocity.y < 0) {
      y = gameRef.size.y / 2;
      _velocity.y = -_velocity.y * _bounceDamping;
    }

    _velocity.x *= 0.99;
    x = x.clamp(size.x / 2, gameRef.size.x - size.x / 2);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    if (other is PlayerComponent) {
      removeFromParent();
      if (gameRef.cubit.state.vibrationEnabled) {
        HapticFeedback.mediumImpact();
      }
      gameRef.cubit.addCoins(5);
      gameRef.pauseEngine();
      gameRef._started = false;
      gameRef._shooting = false;
      gameRef.overlays.add('gameover');
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}

class _Spawner extends Component with HasGameRef<DodgefallGame> {
  _Spawner();
  final Random _rand = Random();
  double _timer = 0;
  Vector2 position = Vector2.zero();

  @override
  void update(double dt) {
    _timer += dt;
    if (_timer > gameRef.spawnInterval) {
      _timer = 0;
      final ob = ObstacleComponent(
        speed: 100 + gameRef.levelNotifier.value * 10,
        health: gameRef.obstacleHealth,
      )..position = Vector2(_rand.nextDouble() * gameRef.size.x, position.y);
      gameRef.add(ob);
    }
  }
}
