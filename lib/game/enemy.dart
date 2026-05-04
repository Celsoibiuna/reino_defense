import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'reino_game.dart';

enum EnemyType { normal, fast, tank }

class Enemy extends SpriteComponent with HasGameReference<ReinoGame> {
  final EnemyType tipo;
  int _waypointIndex = 0;

  // Atributos do inimigo
  late double speed;
  late double vida;
  late int recompensa;

  Enemy(this.tipo) : super(size: Vector2(50, 50), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    // Valores padrão de segurança (failsafe)
    speed = 80;
    vida = 30;
    recompensa = 10;

    try {
      switch (tipo) {
        case EnemyType.normal:
          sprite = await game.loadSprite('enemy_normal.png');
          speed = 80;
          vida = 30;
          recompensa = 10;
          break;
        case EnemyType.fast:
          sprite = await game.loadSprite('enemy_fast.png');
          speed = 150;
          vida = 15;
          recompensa = 15;
          break;
        case EnemyType.tank:
          try {
            // Tentamos carregar o Boss Tank
            sprite = await game.loadSprite('boss_tank.png');
            // Se for a imagem única, o Flame ajusta o tamanho automaticamente.
            // Se for a sprite sheet, você pode voltar a usar o Sprite(image, srcSize...)
          } catch (e) {
            debugPrint("Erro ao carregar boss_tank.png, usando padrão: $e");
            sprite = await game.loadSprite('enemy_normal.png');
          }
          size = Vector2(
            70,
            70,
          ); // Tank é maior que o normal, mas menor que o Boss
          speed = 45;
          vida = 120;
          recompensa = 35;
          break;
      }
    } catch (e) {
      debugPrint("Erro geral no onLoad do inimigo $tipo: $e");
      sprite = await game.loadSprite('enemy_normal.png');
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (game.acabou) return;

    final waypoints = game.waypoints;

    if (_waypointIndex < waypoints.length) {
      Vector2 target = waypoints[_waypointIndex];
      Vector2 direction = target - position;
      double distancia = direction.length;

      // 🔥 AUMENTAMOS A MARGEM (de 5 para 15)
      // Inimigos rápidos (150px/s) podem pular 5 pixels em um único frame de lag.
      // 15 garante que ele detecte o ponto mesmo em alta velocidade.
      if (distancia < 15) {
        _waypointIndex++;
      } else {
        // Move usando o vetor normalizado
        position.add(direction.normalized() * speed * dt);
      }
    } else {
      game.perderVida();
      removeFromParent();
    }
  }

  void levarDano(double dano) {
    vida -= dano;
    if (vida <= 0) {
      // Use EXATAMENTE o nome que você definiu no ReinoGame
      game.ganharMoeda();
      removeFromParent();
    }
  }
}
