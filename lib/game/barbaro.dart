import 'package:flame/components.dart';
import 'reino_game.dart';
import 'enemy.dart';

class Barbaro extends SpriteComponent with HasGameReference<ReinoGame> {
  double vida = 80;
  double speed = 45;

  double ataque = 25;
  double cooldown = 0.5;

  Enemy? alvo;

  Vector2 origem;
  double raio;

  Barbaro({required Vector2 position, required this.origem, required this.raio})
    : super(size: Vector2(40, 40), position: position, anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('barbaro.png');
  }

  @override
  void update(double dt) {
    super.update(dt);

    cooldown -= dt;

    // pega alvo próximo
    alvo ??= _buscarInimigoProximo();

    // se morreu ou sumiu
    if (alvo != null && !alvo!.isMounted) {
      alvo = null;
    }

    if (alvo != null) {
      final direction = alvo!.position - position;

      // correr até alvo
      if (direction.length > 25) {
        position += direction.normalized() * speed * dt;
      } else {
        // 🔥 trava inimigo
        alvo!.bloqueado = true;
        alvo!.bloqueador = this;

        // ataque
        if (cooldown <= 0) {
          alvo!.levarDano(ataque);
          cooldown = 0.5;
        }
      }

      // se inimigo morreu libera
      if (alvo!.vida <= 0) {
        alvo!.bloqueado = false;
        alvo!.bloqueador = null;
        alvo = null;
      }
    } else {
      // voltar para barraca
      final voltar = origem - position;

      if (voltar.length > 10) {
        position += voltar.normalized() * speed * dt;
      }
    }

    if (vida <= 0) {
      if (alvo != null) {
        alvo!.bloqueado = false;
        alvo!.bloqueador = null;
      }

      removeFromParent();
    }
  }

  Enemy? _buscarInimigoProximo() {
    Enemy? maisProximo;
    double menorDistancia = raio;

    for (final enemy in game.children.whereType<Enemy>()) {
      final dist = (enemy.position - position).length;

      if (dist < menorDistancia && !enemy.bloqueado) {
        menorDistancia = dist;
        maisProximo = enemy;
      }
    }

    return maisProximo;
  }
}
