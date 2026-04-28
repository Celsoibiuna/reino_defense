import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'dart:ui';

import 'enemy.dart';
import 'tower.dart';
import 'boss.dart';

class ReinoGame extends FlameGame with TapCallbacks {
  // Caminho correto dos inimigos
  final List<Vector2> waypoints = [
    Vector2(520, 760),
    Vector2(520, 660),
    Vector2(430, 660),
    Vector2(330, 660),
    Vector2(300, 590),
    Vector2(350, 520),
    Vector2(430, 500),
    Vector2(500, 470),
    Vector2(500, 350),
    Vector2(420, 330),
    Vector2(320, 330),
    Vector2(250, 290),
    Vector2(260, 230),
    Vector2(330, 210),
    Vector2(450, 210),
    Vector2(520, 180),
    Vector2(520, 130),
    Vector2(430, 120),
    Vector2(300, 120),
    Vector2(180, 120),
    Vector2(80, 120),
  ];

  double spawnTimer = 0;

  int moedas = 100;
  int vida = 10;

  int wave = 1;
  int inimigosCriados = 0;
  int inimigosWave = 5;

  bool acabou = false;

  TextComponent? hud;
  TextComponent? gameOverText;

  @override
  Future<void> onLoad() async {
    await add(
      SpriteComponent()
        ..sprite = await Sprite.load('background.png')
        ..size = size
        ..position = Vector2.zero()
        ..priority = 0,
    );

    iniciarJogo();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Debug visual dos pontos
    final paint = Paint()..color = const Color(0xFFFF0000);

    for (final ponto in waypoints) {
      canvas.drawCircle(Offset(ponto.x, ponto.y), 6, paint);
    }
  }

  void iniciarJogo() {
    add(Tower()..position = Vector2(100, 280));

    hud = TextComponent(text: '', position: Vector2(20, 20), priority: 10);

    add(hud!);
  }

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

  @override
  void onTapUp(TapUpEvent event) {
    if (acabou) {
      reiniciar();
      return;
    }

    final toque = event.localPosition;

    for (final tower in children.whereType<Tower>()) {
      if ((tower.position - toque).length < 60) {
        if (moedas >= 40) {
          moedas -= 40;
          tower.upgrade();
        }
        return;
      }
    }

    if (moedas >= 50) {
      moedas -= 50;

      add(Tower()..position = toque - Vector2(25, 25));
    }
  }

  void ganharMoeda() {
    moedas += 10;
  }

  void perderVida() {
    vida--;
  }

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

    onLoad();
  }
}
