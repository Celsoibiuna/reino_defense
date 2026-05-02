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

  double range = 150; // 🎯 alcance

  Tower() : super(size: Vector2(100, 100), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('tower.png');

    // começa invisível e pequena
    scale = Vector2.all(0);
    opacity = 0;

    // 🏗️ animação de construção (cresce)
    add(
      ScaleEffect.to(
        Vector2.all(1),
        EffectController(duration: 0.4, curve: Curves.easeOutBack),
      ),
    );

    // ✨ fade-in
    add(OpacityEffect.fadeIn(EffectController(duration: 0.3)));

    // 💨 efeito de "poeira"
    game.add(
      CircleComponent(
          position: position.clone(),
          radius: 15,
          paint: Paint()..color = const Color(0x55AAAAAA),
        )
        ..add(ScaleEffect.to(Vector2.all(2), EffectController(duration: 0.3)))
        ..add(OpacityEffect.fadeOut(EffectController(duration: 0.3))),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    shootTimer += dt;

    // 🔎 pega alvos dentro do alcance
    final targets =
        [
          ...game.children.whereType<Enemy>(),
          ...game.children.whereType<Boss>(),
        ].where((target) {
          return (target.position - position).length <= range;
        }).toList();

    // 🎯 atira
    if (targets.isNotEmpty && shootTimer > 1) {
      shootTimer = 0;

      final alvo = targets.first;

      game.add(Bullet(alvo)..position = position.clone());
    }
  }

  void upgrade() {
    level++;

    // melhora alcance ao upar
    range += 20;

    // ✨ efeito visual de upgrade
    add(
      ScaleEffect.to(Vector2.all(1.3), EffectController(duration: 0.2))
        ..add(ScaleEffect.to(Vector2.all(1), EffectController(duration: 0.2))),
    );
  }
}
