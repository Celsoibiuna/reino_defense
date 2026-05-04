import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'dart:ui';

import 'enemy.dart';
import 'boss.dart';
import 'reino_game.dart';

class Bullet extends SpriteComponent with HasGameReference<ReinoGame> {
  double speed = 300;

  PositionComponent alvo;

  Bullet(this.alvo) : super(size: Vector2(30, 30), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('arrow.png');
  }

  @override
  void update(double dt) {
    super.update(dt);

    // ❌ alvo morreu
    if (!alvo.isMounted) {
      removeFromParent();
      return;
    }

    final direction = alvo.position - position;

    // 🎯 rotação
    angle = direction.angleToSigned(Vector2(1, 0));

    // ✨ rastro
    game.add(
      CircleComponent(
        position: position.clone(),
        radius: 2,
        paint: Paint()..color = const Color(0x55FFFF00),
      )..add(OpacityEffect.fadeOut(EffectController(duration: 0.3))),
    );

    // 💥 impacto
    if (direction.length < 10) {
      if (alvo is Enemy) {
        (alvo as Enemy).levarDano(10);
      } else if (alvo is Boss) {
        (alvo as Boss).levarDano(10);
      }

      // explosão
      game.add(
        CircleComponent(
            position: position.clone(),
            radius: 10,
            paint: Paint()..color = const Color.fromARGB(255, 247, 80, 3),
          )
          ..add(ScaleEffect.to(Vector2.all(2), EffectController(duration: 0.2)))
          ..add(OpacityEffect.fadeOut(EffectController(duration: 0.2))),
      );

      removeFromParent();
      return;
    }

    // movimento
    position += direction.normalized() * speed * dt;

    // ❌ saiu da tela
    if (position.x > game.size.x + 50 ||
        position.x < -50 ||
        position.y > game.size.y + 50 ||
        position.y < -50) {
      removeFromParent();
    }
  }
}
