import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'dart:ui';
import 'bullet.dart';
import 'enemy.dart';
import 'boss.dart';
import 'reino_game.dart';

class Tower extends SpriteComponent with HasGameReference<ReinoGame> {
  double shootTimer = 0;
  int level = 1;
  double range = 150;

  Tower() : super(size: Vector2(100, 100), anchor: Anchor.center, priority: 2);

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('tower.png');

    // Começa invisível e pequena
    scale = Vector2.all(0);
    opacity = 0;

    // Animação de construção
    add(
      ScaleEffect.to(
        Vector2.all(1),
        EffectController(duration: 0.4, curve: Curves.easeOutBack),
      ),
    );

    add(OpacityEffect.fadeIn(EffectController(duration: 0.3)));

    // Efeito de poeira na base
    game.add(
      CircleComponent(
          position: position.clone(),
          radius: 15,
          paint: Paint()..color = const Color(0x55AAAAAA),
          priority: 1, // Fica abaixo da torre
        )
        ..add(ScaleEffect.to(Vector2.all(2.5), EffectController(duration: 0.4)))
        ..add(OpacityEffect.fadeOut(EffectController(duration: 0.4)))
        ..add(
          RemoveEffect(delay: 0.4),
        ), // Garante que o círculo suma da memória
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (game.acabou) return;

    shootTimer += dt;

    if (shootTimer >= 1.0) {
      // Forma alternativa sem precisar de pacotes externos:
      final alvos = game.children.where(
        (c) =>
            (c is Enemy || c is Boss) &&
            (c as PositionComponent).position.distanceTo(position) <= range,
      );

      if (alvos.isNotEmpty) {
        shootTimer = 0;
        game.add(
          Bullet(alvos.first as PositionComponent)..position = position.clone(),
        );
      }
    }
  }

  void upgrade() {
    level++;
    range += 25;

    // ✨ Efeito visual de upgrade (pulso)
    add(
      SequenceEffect([
        ScaleEffect.to(Vector2.all(1.2), EffectController(duration: 0.1)),
        ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.1)),
      ]),
    );
  }
}
