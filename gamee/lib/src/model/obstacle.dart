import 'dart:math';

class Obstacle {
  final int id;
  double x;
  double y;
  final double speed;
  int health;
  final int maxHealth;

  Obstacle({
    required this.id,
    required this.x,
    this.y = 0,
    this.speed = 0.3,
    this.health = 1,
  }) : maxHealth = health;

  factory Obstacle.random(int id, int health) {
    final rand = Random();
    return Obstacle(
      id: id,
      x: rand.nextDouble(),
      speed: 0.3 + rand.nextDouble(),
      health: health,
    );
  }
}
