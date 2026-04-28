import 'package:flame/components.dart';
import 'dart:ui';
import 'reino_game.dart';

class Boss extends RectangleComponent {
  int life = 20;

  Boss()
    : super(
        size: Vector2(80, 80),
        paint: Paint()..color = const Color(0xFF800080),
      );

  @override
  void update(double dt) {
    super.update(dt);

    position.x += 30 * dt;

    final game = findGame() as ReinoGame;

    if (life <= 0) {
      game.moedas += 100;
      removeFromParent();
    }

    if (position.x > game.size.x) {
      game.perderVida();
      game.perderVida();
      game.perderVida();
      removeFromParent();
    }
  }

  void hit() {
    life--;
  }
}
