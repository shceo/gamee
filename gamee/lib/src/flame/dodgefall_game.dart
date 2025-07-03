import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/input.dart';
import '../view_model/game_cubit.dart';
import 'bullet_component.dart';

class DodgefallGame extends FlameGame
    with HasCollisionDetection, TapDetector, PanDetector {
  DodgefallGame(this.cubit);

  final GameCubit cubit;
  late final PlayerComponent player;
  late final _Spawner spawner;
  bool _started = false;
  bool _shooting = false;
  double _shootTimer = 0;
  double get _shootInterval => cubit.shootInterval;

  void _shoot() {
    final bulletPos =
        Vector2(player.x, player.y - player.size.y / 2 - 5);
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
    children.whereType<ObstacleComponent>().forEach((e) => e.removeFromParent());
    children.whereType<BulletComponent>().forEach((b) => b.removeFromParent());
    player.position = Vector2(size.x / 2, size.y - 60);
    pauseEngine();
    overlays
      ..remove('gameover')
      ..add('start');
    cubit.restart();
  }

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'player.png',
      'enemy.png',
    ]);
    player = PlayerComponent()
      ..position = Vector2(size.x / 2, size.y - 60);
    add(player);
    spawner = _Spawner(cubit)..position = Vector2.zero();
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
    final newX = (player.x + dx).clamp(player.size.x / 2, size.x - player.size.x / 2);
    player.position = Vector2(newX, player.y);
  }

  @override
  void update(double dt) {
    super.update(dt);
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
  ObstacleComponent({required this.speed})
      : super(size: Vector2.all(30), anchor: Anchor.center);

  final double speed;
  int health = 1;

  @override
  Future<void> onLoad() async {
    sprite = Sprite(gameRef.images.fromCache('enemy.png'));
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    y += speed * dt;
    if (y > gameRef.size.y) {
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is PlayerComponent) {
      removeFromParent();
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
  _Spawner(this.cubit);

  final GameCubit cubit;
  final Random _rand = Random();
  double _timer = 0;
  Vector2 position = Vector2.zero();

  @override
  void update(double dt) {
    _timer += dt;
    if (_timer > 1) {
      _timer = 0;
      final ob = ObstacleComponent(speed: 100)
        ..position = Vector2(_rand.nextDouble() * gameRef.size.x, position.y);
      gameRef.add(ob);
    }
  }
}
