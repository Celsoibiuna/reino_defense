import 'package:flame/components.dart';
import 'reino_game.dart';
import 'enemy.dart';

class Barbaro extends SpriteComponent with HasGameReference<ReinoGame> {
  double vida = 50;
  double speed = 40;

  double ataque = 20;
  double cooldown = 0;

  Enemy? alvo;

  // 🔥 NOVO
  final Vector2 origem;
  final double raio;

  Barbaro({required Vector2 position, required this.origem, required this.raio})
    : super(size: Vector2(35, 35), position: position, anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('barbaro.png');
  }

  @override
  void update(double dt) {
    super.update(dt);

    cooldown -= dt;

    // =========================
    // 🔥 VOLTAR PRA BASE
    // =========================
    if ((position - origem).length > raio) {
      final voltar = origem - position;
      position += voltar.normalized() * speed * dt;
      return;
    }

    // =========================
    // 🔥 BUSCAR ALVO (SÓ DENTRO DO RAIO)
    // =========================
    alvo = game.children
        .whereType<Enemy>()
        .where((enemy) => (enemy.position - origem).length <= raio)
        .fold<Enemy?>(null, (prev, enemy) {
          if (prev == null) return enemy;

          return (enemy.position - position).length <
                  (prev.position - position).length
              ? enemy
              : prev;
        });

    // =========================
    // 🔥 COMPORTAMENTO
    // =========================
    if (alvo != null && alvo!.isMounted) {
      final direction = alvo!.position - position;

      // mover até o alvo
      if (direction.length > 20) {
        position += direction.normalized() * speed * dt;
      } else {
        // atacar
        if (cooldown <= 0) {
          alvo!.levarDano(ataque);
          cooldown = 0.5;
        }
      }
    } else {
      // 🔥 SEM ALVO → VOLTA PRA BASE (IDLE)
      final direction = origem - position;

      if (direction.length > 5) {
        position += direction.normalized() * speed * dt;
      }
    }

    // =========================
    // 🔥 MORTE
    // =========================
    if (vida <= 0) {
      removeFromParent();
    }
  }
}
