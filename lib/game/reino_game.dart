import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

import 'enemy.dart';
import 'tower.dart';
import 'boss.dart';

class ReinoGame extends FlameGame with TapCallbacks {
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
    iniciarJogo();
  }

  void iniciarJogo() {
    add(Tower()..position = Vector2(100, 280));

    hud = TextComponent(text: '', position: Vector2(20, 20));

    add(hud!);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (acabou) return;

    spawnTimer += dt;

    if (spawnTimer > 1.5 && inimigosCriados < inimigosWave) {
      spawnTimer = 0;

      add(Enemy()..position = Vector2(0, 300));

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
      add(Boss()..position = Vector2(0, 280));

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

    if (moedas >= 50) {
      moedas -= 50;

      add(Tower()..position = event.localPosition - Vector2(25, 25));
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

    iniciarJogo();
  }
}
