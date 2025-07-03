import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/input.dart';
import '../view_model/game_cubit.dart';
import 'bullet_component.dart';

class DodgefallGame extends FlameGame with HasCollisionDetection, TapDetector {
  DodgefallGame(this.cubit);

  final GameCubit cubit;
  late final PlayerComponent player;
  late final _Spawner spawner;

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'assets/images/player.png',
      'assets/images/enemy.png',
    ]);
    player = PlayerComponent()..position = size / 2;
    add(player);
    spawner = _Spawner(cubit)..position = Vector2.zero();
    add(spawner);
  }

  @override
  void onTapDown(TapDownInfo info) {
    final bulletPos =
        Vector2(player.x, player.y - player.size.y / 2 - 5);
    add(BulletComponent(bulletPos));
    super.onTapDown(info);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    final delta = info.delta.global;
    player.position.add(delta);
    player.position.clamp(Vector2.zero(), size - player.size);
  }
}

class PlayerComponent extends SpriteComponent
    with HasGameRef<DodgefallGame>, CollisionCallbacks {
  PlayerComponent() : super(size: Vector2.all(30), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = Sprite(gameRef.images.fromCache('assets/images/player.png'));
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
    sprite = Sprite(gameRef.images.fromCache('assets/images/enemy.png'));
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
