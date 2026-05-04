import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Path;

import 'barracks.dart';
import 'enemy.dart';
import 'tower.dart';
import 'boss.dart';

class ReinoGame extends FlameGame with TapCallbacks {
  // =========================
  // CAMINHO
  // =========================
  final List<Vector2> waypoints = [
    Vector2(880, 780),
    Vector2(800, 750),
    Vector2(720, 720),
    Vector2(700, 620),
    Vector2(690, 590),
    Vector2(570, 560),
    Vector2(540, 620),
    Vector2(520, 680),
    Vector2(500, 720),
    Vector2(480, 750),
    Vector2(380, 680),
    Vector2(250, 550),
    Vector2(180, 550),
    Vector2(150, 550),
    Vector2(160, 450),
    Vector2(200, 350),
    Vector2(160, 250),
  ];

  // =========================
  // SPOTS DE CONSTRUÇÃO
  // =========================
  final List<Vector2> _originalSpots = [
    Vector2(50, 490),
    Vector2(220, 630),
    Vector2(220, 500),
    Vector2(420, 650),
    Vector2(410, 250),
  ];

  late List<Vector2> buildSpots;

  // =========================
  // VARIÁVEIS
  // =========================
  double spawnTimer = 0;
  int moedas = 100;
  int vida = 10;
  int wave = 1;
  int inimigosCriados = 0;
  int inimigosWave = 5;

  bool acabou = false;

  // 🔥 alterna entre Tower e Barracks
  bool construirBarracks = false;

  TextComponent? hud;

  // =========================
  // LOAD
  // =========================
  @override
  Future<void> onLoad() async {
    buildSpots = _originalSpots.map((e) => e.clone()).toList();
    await carregarBackground();
    iniciarJogo();
  }

  Future<void> carregarBackground() async {
    final sprite = await loadSprite('background.png');

    await add(
      SpriteComponent()
        ..sprite = sprite
        ..size = size
        ..position = Vector2.zero()
        ..priority = -1,
    );
  }

  void iniciarJogo() {
    hud = TextComponent(text: '', position: Vector2(20, 20), priority: 10);
    add(hud!);
  }

  // =========================
  // UPDATE
  // =========================
  @override
  void update(double dt) {
    super.update(dt);

    if (acabou) return;

    hud?.text = 'Vida: $vida   Moedas: $moedas   Wave: $wave';

    spawnTimer += dt;

    if (spawnTimer > 1.5 && inimigosCriados < inimigosWave) {
      spawnTimer = 0;

      add(Enemy(tipoInimigo())..position = waypoints.first.clone());

      inimigosCriados++;
    }

    final semInimigos =
        children.whereType<Enemy>().isEmpty &&
        children.whereType<Boss>().isEmpty;

    if (semInimigos && inimigosCriados >= inimigosWave) {
      proximaWave();
    }
  }

  // =========================
  // WAVES
  // =========================
  void proximaWave() {
    wave++;
    inimigosCriados = 0;

    if (wave % 5 == 0) {
      final isTank = wave % 10 == 0;

      add(
        Boss(isTank ? BossType.tank : BossType.normal)
          ..position = waypoints.first.clone(),
      );

      inimigosWave += 5;
    } else {
      inimigosWave += 3;
    }
  }

  // =========================
  // TIPOS DE INIMIGO
  // =========================
  EnemyType tipoInimigo() {
    if (wave < 3) return EnemyType.normal;

    if (wave < 6) {
      return (inimigosCriados % 2 == 0) ? EnemyType.fast : EnemyType.normal;
    }

    if (wave < 9) {
      return (inimigosCriados % 2 == 0) ? EnemyType.tank : EnemyType.fast;
    }

    return EnemyType.values[inimigosCriados % EnemyType.values.length];
  }

  // =========================
  // VIDA
  // =========================
  void perderVida() {
    if (acabou) return;

    vida--;

    if (vida <= 0) {
      vida = 0;
      gameOver();
    }
  }

  void gameOver() {
    acabou = true;

    add(
      TextComponent(
        text: 'GAME OVER\nToque para Reiniciar',
        position: size / 2,
        anchor: Anchor.center,
        priority: 100,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.red,
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // =========================
  // TOQUE
  // =========================
  @override
  void onTapUp(TapUpEvent event) {
    if (acabou) {
      reiniciar();
      return;
    }

    final toque = event.localPosition;

    for (final spot in buildSpots) {
      if ((spot - toque).length < 30) {
        if (moedas >= 50) {
          moedas -= 50;

          if (construirBarracks) {
            // 👉 Barracks direita
            add(Barracks(position: spot.clone() + Vector2(25, 0)));
          } else {
            // 👉 Torre esquerda
            add(Tower()..position = spot.clone() + Vector2(-25, 0));
          }

          // alterna
          construirBarracks = !construirBarracks;
        }
        return;
      }
    }
  }

  // =========================
  // RESET (SEM BUG)
  // =========================
  void reiniciar() {
    removeAll(children);

    spawnTimer = 0;
    moedas = 100;
    vida = 10;
    wave = 1;
    inimigosCriados = 0;
    inimigosWave = 5;

    buildSpots = _originalSpots.map((e) => e.clone()).toList();

    acabou = false;

    carregarBackground();
    iniciarJogo();
  }

  void ganharMoeda() {
    moedas += 10;
  }

  // =========================
  // DEBUG (SPOTS)
  // =========================
  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final paint = Paint()..color = const Color.fromARGB(80, 200, 255, 200);

    for (final spot in buildSpots) {
      canvas.drawCircle(Offset(spot.x, spot.y), 25, paint);
    }
  }
}
