import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

import 'enemy.dart';
import 'tower.dart';
import 'boss.dart';

class ReinoGame extends FlameGame with TapCallbacks {
  // =========================
  // CAMINHO DOS INIMIGOS
  // =========================
  final List<Vector2> waypoints = [
    Vector2(880, 780),
    Vector2(800, 750),
    Vector2(720, 720),
    Vector2(700, 620),
    Vector2(690, 560),
    Vector2(570, 560),
    Vector2(500, 750),
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
  // PONTOS DE TORRE
  // =========================
  final List<Vector2> buildSpots = [
    Vector2(50, 500),
    Vector2(220, 630),
    Vector2(220, 500),
    Vector2(420, 670),
    Vector2(410, 250),
  ];

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

  TextComponent? hud;
  TextComponent? gameOverText;

  // =========================
  // LOAD
  // =========================
  @override
  Future<void> onLoad() async {
    await carregarBackground();
    iniciarJogo();
  }

  Future<void> carregarBackground() async {
    final sprite = await loadSprite('background.png');

    await add(
      SpriteComponent()
        ..sprite = sprite
        ..size =
            size // 🔥 ocupa tela toda
        ..position = Vector2.zero()
        ..priority = 0,
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

    spawnTimer += dt;

    if (spawnTimer > 1.5 && inimigosCriados < inimigosWave) {
      spawnTimer = 0;

      add(Enemy()..position = waypoints.first.clone());

      inimigosCriados++;
    }

    if (children.whereType<Enemy>().isEmpty &&
        children.whereType<Boss>().isEmpty &&
        inimigosCriados >= inimigosWave) {
      proximaWave();
    }

    hud?.text = 'Vida: $vida   Moedas: $moedas   Wave: $wave';

    if (vida <= 0) {
      fimDeJogo();
    }
  }

  // =========================
  // WAVES
  // =========================
  void proximaWave() {
    wave++;
    inimigosCriados = 0;

    if (wave % 5 == 0) {
      add(Boss()..position = waypoints.first.clone());
      inimigosWave = 0;
    } else {
      inimigosWave += 3;
    }
  }

  // =========================
  // TOQUE (CONSTRUIR TORRES)
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
        if (!ocupado(spot) && moedas >= 50) {
          moedas -= 50;
          add(Tower()..position = spot.clone());
        }
        return;
      }
    }
  }

  bool ocupado(Vector2 spot) {
    return children.whereType<Tower>().any(
      (t) => (t.position - spot).length < 10,
    );
  }

  // =========================
  // ECONOMIA
  // =========================
  void ganharMoeda() {
    moedas += 10;
  }

  void perderVida() {
    vida--;
  }

  // =========================
  // GAME OVER
  // =========================
  void fimDeJogo() {
    acabou = true;

    gameOverText = TextComponent(
      text: 'GAME OVER',
      position: Vector2(size.x / 2 - 80, size.y / 2),
      scale: Vector2.all(2),
      priority: 20,
    );

    add(gameOverText!);
  }

  void reiniciar() {
    removeAll(children);

    spawnTimer = 0;
    moedas = 100;
    vida = 10;

    wave = 1;
    inimigosCriados = 0;
    inimigosWave = 5;

    acabou = false;

    iniciarJogo(); // 🔥 CORRIGIDO
  }

  // =========================
  // DEBUG (APENAS SPOTS)
  // =========================
  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final spotPaint = Paint()..color = const Color(0x5500FF00);

    for (final spot in buildSpots) {
      canvas.drawCircle(Offset(spot.x, spot.y), 25, spotPaint);
    }
  }
}
