import 'package:flame/components.dart';
import 'reino_game.dart';
import 'dart:ui';

class Boss extends SpriteComponent with HasGameReference<ReinoGame> {
  int _waypointIndex = 0;

  double speed = 40;
  double vida = 200;
  double vidaMax = 200;

  bool morreu = false;

  Boss() : super(size: Vector2(140, 140), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('boss.png');
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final barWidth = size.x;
    const barHeight = 10.0;

    // fundo (vermelho)
    final bgPaint = Paint()..color = const Color(0xFFFF0000);

    canvas.drawRect(
      Rect.fromLTWH(-barWidth / 2, -size.y / 2 - 25, barWidth, barHeight),
      bgPaint,
    );

    // vida atual (verde)
    final lifePercent = (vida / vidaMax).clamp(0, 1);

    final lifePaint = Paint()..color = const Color(0xFF00FF00);

    canvas.drawRect(
      Rect.fromLTWH(
        -barWidth / 2,
        -size.y / 2 - 25,
        barWidth * lifePercent,
        barHeight,
      ),
      lifePaint,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    final game = findGame() as ReinoGame;

    // 🔥 MORTE
    if (!morreu && vida <= 0) {
      morreu = true;

      game.ganharMoeda();
      game.moedas += 90;

      removeFromParent();
      return;
    }

    final waypoints = game.waypoints;

    // MOVIMENTO
    if (_waypointIndex < waypoints.length) {
      final target = waypoints[_waypointIndex];
      final direction = target - position;

      if (direction.length < 10) {
        _waypointIndex++;
      } else {
        position += direction.normalized() * speed * dt;
      }
    } else {
      // chegou no castelo
      if (!morreu) {
        morreu = true;

        game.perderVida();
        game.perderVida();
        game.perderVida();
      }

      removeFromParent();
    }
  }

  void hit() {
    vida -= 10;
  }
}
