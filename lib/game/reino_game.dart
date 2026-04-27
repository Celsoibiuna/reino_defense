import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

import 'enemy.dart';
import 'tower.dart';

class ReinoGame extends FlameGame with TapCallbacks {
  double spawnTimer = 0;

  int moedas = 100;
  int vida = 10;

  TextComponent? hud;
  TextComponent? gameOverText;

  bool acabou = false;

  @override
  Future<void> onLoad() async {
    add(Tower()..position = Vector2(100, 280));

    hud = TextComponent(text: '', position: Vector2(20, 20));

    add(hud!);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (acabou) return;

    spawnTimer += dt;

    if (spawnTimer > 2) {
      spawnTimer = 0;

      add(Enemy()..position = Vector2(0, 300));
    }

    hud?.text = 'Vida: $vida   Moedas: $moedas';

    if (vida <= 0) {
      fimDeJogo();
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

  void reiniciar() {
    removeAll(children);
    spawnTimer = 0;
    moedas = 100;
    vida = 10;
    acabou = false;

    add(Tower()..position = Vector2(100, 280));

    hud = TextComponent(text: '', position: Vector2(20, 20));

    add(hud!);
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
}
