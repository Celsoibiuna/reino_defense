import 'package:flame/components.dart';
import 'dart:ui';

import 'enemy.dart';
import 'boss.dart';
import 'reino_game.dart';

class Bullet extends CircleComponent {
  double speed = 300;

  PositionComponent alvo;

  Bullet(this.alvo)
    : super(
        radius: 6,
        paint: Paint()..color = const Color(0xFFFFFF00),
        anchor: Anchor.center,
      );

  @override
  void update(double dt) {
    super.update(dt);

    if (!alvo.isMounted) {
      removeFromParent();
      return;
    }

    final direction = alvo.position - position;

    if (direction.length < 10) {
      // acertou
      if (alvo is Enemy) {
        (alvo as Enemy).levarDano(10);
      }

      if (alvo is Boss) {
        (alvo as Boss).hit();
      }

      removeFromParent();
      return;
    }

    position += direction.normalized() * speed * dt;
  }
}
