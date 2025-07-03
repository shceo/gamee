import 'dart:math';

class Obstacle {
  final int id;
  double x; // 0..1
  double y; // 0..1
  final double speed;

  Obstacle({required this.id, required this.x, this.y = 0, this.speed = 0.3});

  factory Obstacle.random(int id) {
    final rand = Random();
    return Obstacle(id: id, x: rand.nextDouble(), speed: 0.3 + rand.nextDouble());
  }
}
