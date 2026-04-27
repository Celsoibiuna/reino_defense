import 'package:flame/components.dart';
import 'dart:ui';
import 'reino_game.dart';

class Enemy extends RectangleComponent {
  int life = 3;

  Enemy()
    : super(
        size: Vector2(40, 40),
        paint: Paint()..color = const Color(0xFFFF0000),
      );

  @override
  void update(double dt) {
    super.update(dt);

    position.x += 60 * dt;

    final game = findGame() as ReinoGame;

    if (life <= 0) {
      game.ganharMoeda();
      removeFromParent();
    }

    if (position.x > game.size.x) {
      game.perderVida();
      removeFromParent();
    }
  }

  void hit() {
    life--;
  }
}
