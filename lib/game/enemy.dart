import 'package:flame/components.dart';
import 'reino_game.dart';

class Enemy extends SpriteComponent with HasGameReference<ReinoGame> {
  int _waypointIndex = 0;

  double speed = 80;
  double vida = 30;

  Enemy() : super(size: Vector2(90, 90), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('enemy.png'); // 👈 mudou aqui
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (vida <= 0) {
      game.ganharMoeda();
      removeFromParent();
      return;
    }

    final waypoints = game.waypoints;

    if (_waypointIndex < waypoints.length) {
      final target = waypoints[_waypointIndex];
      final direction = target - position;

      if (direction.length < 5) {
        _waypointIndex++;
      } else {
        position += direction.normalized() * speed * dt;
      }
    } else {
      game.perderVida();
      removeFromParent();
    }
  }

  void levarDano(double dano) {
    vida -= dano;
  }
}
