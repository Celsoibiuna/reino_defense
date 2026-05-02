import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' hide Path;
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
  // TORRES
  // =========================
  final List<Vector2> buildSpots = [
    Vector2(50, 490),
    Vector2(220, 630),
    Vector2(220, 500),
    Vector2(420, 650),
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

    // 1. Atualiza HUD
    hud?.text = 'Vida: $vida   Moedas: $moedas   Wave: $wave';

    // 2. Lógica de Spawn
    spawnTimer += dt;
    if (spawnTimer > 1.5 && inimigosCriados < inimigosWave) {
      spawnTimer = 0;
      if (waypoints.isNotEmpty) {
        add(Enemy(tipoInimigo())..position = waypoints.first.clone());
        inimigosCriados++;
      }
    }

    // 3. Verificação de Próxima Wave
    final semInimigos =
        children.whereType<Enemy>().isEmpty &&
        children.whereType<Boss>().isEmpty;

    if (semInimigos && inimigosCriados >= inimigosWave) {
      proximaWave();
    }
  }

  // =========================
  // WAVES E TIPOS
  // =========================
  void proximaWave() {
    wave++;
    inimigosCriados = 0;
    if (wave % 5 == 0) {
      add(Boss()..position = waypoints.first.clone());
      inimigosWave += 5;
    } else {
      inimigosWave += 3;
    }
  }

  EnemyType tipoInimigo() {
    if (wave < 3) return EnemyType.normal;
    if (wave < 6)
      return (inimigosCriados % 2 == 0) ? EnemyType.fast : EnemyType.normal;
    if (wave < 9)
      return (inimigosCriados % 2 == 0) ? EnemyType.tank : EnemyType.fast;
    return EnemyType.values[inimigosCriados % EnemyType.values.length];
  }

  // =========================
  // VIDA E GAME OVER
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
  // EVENTOS (TOQUE)
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
  // RESET E UTILITÁRIOS
  // =========================
  void reiniciar() {
    removeAll(children);
    spawnTimer = 0;
    moedas = 100;
    vida = 10;
    wave = 1;
    inimigosCriados = 0;
    inimigosWave = 5;
    acabou = false;
    carregarBackground();
    iniciarJogo();
  }

  void ganharMoeda() {
    moedas += 10;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = const Color.fromARGB(80, 200, 255, 200);
    for (final spot in buildSpots) {
      canvas.drawCircle(Offset(spot.x, spot.y), 25, paint);
    }
  }
}
