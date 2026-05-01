import 'package:flame/components.dart';
import 'dart:ui';
import 'reino_game.dart';

class Boss extends SpriteComponent with HasGameReference<ReinoGame> {
  int _waypointIndex = 0;

  double speed = 40;
  double maxLife = 100;
  double life = 100;

  Boss() : super(size: Vector2(140, 140), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('boss.png');
  }

  @override
  void update(double dt) {
    super.update(dt);

    final waypoints = game.waypoints;

    if (life <= 0) {
      game.moedas += 150;
      removeFromParent();
      return;
    }

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
      game.perderVida();
      game.perderVida();
      removeFromParent();
    }
  }

  // ❤️ barra de vida
  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final double barWidth = size.x;
    final double barHeight = 8.0;

    final lifePercent = life / maxLife;

    final bg = Paint()..color = const Color(0xFF550000);
    final hp = Paint()..color = const Color(0xFFFF0000);

    canvas.drawRect(
      Rect.fromLTWH(-barWidth / 2, -size.y / 2 - 15, barWidth, barHeight),
      bg,
    );

    canvas.drawRect(
      Rect.fromLTWH(
        -barWidth / 2,
        -size.y / 2 - 15,
        barWidth * lifePercent,
        barHeight,
      ),
      hp,
    );
  }

  void hit() {
    life -= 5;
  }
}
