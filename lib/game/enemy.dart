import 'package:flame/components.dart';
import 'reino_game.dart';

class Enemy extends SpriteComponent {
  int life = 3;
  int pontoAtual = 0;
  double speed = 70;

  Enemy() : super(size: Vector2(80, 80), priority: 10);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('enemy.png');

    final game = findGame() as ReinoGame;

    position = game.waypoints.first.clone();

    anchor = Anchor.center;
  }

  @override
  void update(double dt) {
    super.update(dt);

    final game = findGame() as ReinoGame;

    if (life <= 0) {
      game.ganharMoeda();
      removeFromParent();
      return;
    }

    final waypoints = game.waypoints;

    if (pontoAtual < waypoints.length - 1) {
      final alvo = waypoints[pontoAtual + 1];

      final direcao = (alvo - position).normalized();

      position += direcao * speed * dt;

      if (position.distanceTo(alvo) < 10) {
        pontoAtual++;
      }
    } else {
      game.perderVida();
      removeFromParent();
    }
  }

  void hit() {
    life--;
  }
}
