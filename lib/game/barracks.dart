import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'dart:ui';
import 'dart:math';

import 'reino_game.dart';
import 'barbaro.dart';

class Barracks extends SpriteComponent with HasGameReference<ReinoGame> {
  double spawnTimer = 0;

  final double range = 120;
  final int maxBarbaros = 3;

  // 🔥 lista própria de bárbaros dessa barraca
  final List<Barbaro> meusBarbaros = [];

  Barracks({required Vector2 position})
    : super(
        size: Vector2(70, 70),
        position: position,
        anchor: Anchor.center,
        priority: 2,
      );

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('barracks.png');

    // 🎬 efeito
    scale = Vector2.all(0);
    add(
      ScaleEffect.to(
        Vector2.all(1),
        EffectController(duration: 0.4, curve: Curves.easeOutBack),
      ),
    );
    add(OpacityEffect.fadeIn(EffectController(duration: 0.3)));

    _spawnBarbaro();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (game.acabou) return;

    spawnTimer += dt;

    // 🔥 limpa mortos da lista
    meusBarbaros.removeWhere((b) => !b.isMounted);

    if (spawnTimer >= 10) {
      spawnTimer = 0;

      if (meusBarbaros.length < maxBarbaros) {
        _spawnBarbaro();
      }
    }
  }

  // =========================
  // SPAWN
  // =========================
  void _spawnBarbaro() {
    final offset = _posicaoAleatoriaNoRange();

    final barbaro = Barbaro(
      position: position.clone() + offset,
      origem: position.clone(),
      raio: range,
    );

    meusBarbaros.add(barbaro);
    game.add(barbaro);
  }

  // =========================
  // POSIÇÃO ALEATÓRIA
  // =========================
  Vector2 _posicaoAleatoriaNoRange() {
    final rand = Random();

    final angle = rand.nextDouble() * 2 * pi;
    final distance = rand.nextDouble() * range;

    return Vector2(cos(angle) * distance, sin(angle) * distance);
  }

  // =========================
  // DEBUG
  // =========================
  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final paint = Paint()
      ..color = const Color.fromARGB(50, 0, 255, 0)
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(Offset.zero, range, paint);
  }
}
