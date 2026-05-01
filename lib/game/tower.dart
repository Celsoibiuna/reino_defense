import 'package:flame/components.dart';

import 'bullet.dart';
import 'enemy.dart';
import 'boss.dart';
import 'reino_game.dart';

class Tower extends SpriteComponent with HasGameReference<ReinoGame> {
  double shootTimer = 0;
  int level = 1;

  Tower() : super(size: Vector2(70, 70), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('tower.png');
  }

  @override
  void update(double dt) {
    super.update(dt);

    shootTimer += dt;

    // 🔎 pega todos os alvos (inimigos + boss)
    final targets = [
      ...game.children.whereType<Enemy>(),
      ...game.children.whereType<Boss>(),
    ];

    // 🎯 se tiver alvo, atira
    if (targets.isNotEmpty && shootTimer > 1) {
      shootTimer = 0;

      final alvo = targets.first;

      game.add(Bullet(alvo)..position = position.clone());
    }
  }

  void upgrade() {
    level++;
  }
}
