import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'dodgefall_game.dart' show DodgefallGame, ObstacleComponent;

class BulletComponent extends RectangleComponent
    with HasGameRef<DodgefallGame>, CollisionCallbacks {
  BulletComponent(Vector2 position)
      : super(
          position: position,
          size: Vector2(4, 10),
          paint: Paint()..color = const Color(0xFFFFFF00),
          anchor: Anchor.center,
        );

  @override
  void update(double dt) {
    super.update(dt);
    y -= 300 * dt;
    if (y < 0) removeFromParent();
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is ObstacleComponent) {
      other.health -= gameRef.cubit.bulletDamage;
      if (other.health <= 0) {
        other.removeFromParent();
        gameRef.cubit.addCoins(5);
      }
      removeFromParent();
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}
