import 'package:flame/components.dart';
import 'package:flutter/foundation.dart'; // 🔥 Necessário para o debugPrint
import 'reino_game.dart';

// 1. Definição dos tipos
enum EnemyType { normal, fast, tank }

// 2. Classe corrigida (HasGameReference remove o "risco" no VS Code)
class Enemy extends SpriteComponent with HasGameReference<ReinoGame> {
  final EnemyType tipo;
  int _waypointIndex = 0;

  // Variáveis late devem ser inicializadas no onLoad
  late double speed;
  late double vida;
  late int recompensa;

  // Construtor
  Enemy(this.tipo) : super(size: Vector2(50, 50), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    try {
      // 3. Configura atributos e imagens baseados no tipo
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
            // Usamos o comando que 'recorta' apenas o primeiro ogre da imagem
            final image = await game.images.load('boss_tank.png');
            sprite = Sprite(
              image,
              srcPosition: Vector2(0, 0), // Começa no topo esquerdo
              srcSize: Vector2(
                256,
                256,
              ), // Tamanho de UM ogre na imagem (ajuste se necessário)
            );
          } catch (e) {
            debugPrint("Erro crítico ao carregar boss_tank.png: $e");
            sprite = await game.loadSprite(
              'enemy_normal.png',
            ); // Failsafe para não travar
          }

          size = Vector2(80, 80);
          speed = 40;
          vida = 100;
          recompensa = 30;
          break;
      }
    } catch (e) {
      // Caso a imagem falhe, o código abaixo evita que o jogo pare na Wave 6
      debugPrint("Erro ao carregar asset para o tipo $tipo: $e");
      sprite = await game.loadSprite('enemy_normal.png');
      speed = 80;
      vida = 30;
      recompensa = 10;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Se o jogo acabou, o inimigo para de andar
    if (game.acabou) return;
    // Como mudamos para HasGameReference, usamos 'game' em vez de 'gameRef'
    final waypoints = game.waypoints;

    if (_waypointIndex < waypoints.length) {
      Vector2 target = waypoints[_waypointIndex];
      Vector2 direction = target - position;

      // Distância de 10 para evitar que inimigos rápidos "travem"
      if (direction.length < 10) {
        _waypointIndex++;
      } else {
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
      game.moedas += recompensa;
      removeFromParent();
    }
  }
}
