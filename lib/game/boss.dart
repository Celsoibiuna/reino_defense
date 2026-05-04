import 'package:flame/components.dart';
import 'reino_game.dart';
import 'dart:ui';

// 🔥 TIPOS DE BOSS
enum BossType { normal, tank }

class Boss extends SpriteComponent with HasGameReference<ReinoGame> {
  final BossType type;

  int _waypointIndex = 0;

  double speed = 40;
  double vida = 200;
  double vidaMax = 200;

  bool morreu = false;

  Boss(this.type) : super(size: Vector2(140, 140), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    switch (type) {
      case BossType.normal:
        sprite = await game.loadSprite('boss.png');
        size = Vector2(140, 140);
        speed = 60;
        vida = 200;
        vidaMax = 200;
        break;

      case BossType.tank:
        sprite = await game.loadSprite('boss_tank.png');
        size = Vector2(180, 180);
        speed = 30;
        vida = 400;
        vidaMax = 400;
        break;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final barWidth = size.x;
    const barHeight = 10.0;

    final bgPaint = Paint()..color = const Color(0xFFFF0000);
    canvas.drawRect(
      Rect.fromLTWH(-barWidth / 2, -size.y / 2 - 25, barWidth, barHeight),
      bgPaint,
    );

    final lifePercent = (vida / vidaMax).clamp(0.0, 1.0);
    final lifePaint = Paint()
      ..color = type == BossType.tank
          ? const Color(0xFF00FFFF)
          : const Color(0xFF00FF00);

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

    // 🔥 CORREÇÃO: Não use 'final game = findGame()'.
    // Como você usa HasGameReference, basta usar a variável 'game' que já existe.
    if (game.acabou) return;

    // MORTE
    // MORTE DO BOSS
    // No boss.dart (dentro do if da morte)
    if (!morreu && vida <= 0) {
      morreu = true;

      game.ganharMoeda(); // 🔥 Agora o VS Code vai reconhecer porque você criou no ReinoGame!

      if (type == BossType.tank) {
        game.moedas += 190;
      } else {
        game.moedas += 90;
      }

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
      // CHEGOU NO CASTELO
      if (!morreu) {
        morreu = true;

        if (type == BossType.tank) {
          // Tank tira 4 vidas
          game.perderVida();
          game.perderVida();
          game.perderVida();
          game.perderVida();
        } else {
          // Normal tira 3 vidas
          game.perderVida();
          game.perderVida();
          game.perderVida();
        }
      }
      removeFromParent();
    }
  }

  // Método para as balas chamarem
  void levarDano(double dano) {
    if (type == BossType.tank) {
      vida -= dano * 0.5; // 🔥 Tank tem resistência (recebe metade do dano)
    } else {
      vida -= dano;
    }
  }
}
