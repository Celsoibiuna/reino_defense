import 'package:flame/components.dart';
import '../lib/game/enemy.dart';

class Bullet extends SpriteComponent {
  final Enemy alvo;
  double speed = 350; // Um pouco mais rápido para não "errar" o alvo
  double dano = 10;

  // Usamos o construtor super para definir as propriedades iniciais
  Bullet({required Vector2 posicaoInicial, required this.alvo})
    : super(
        position: posicaoInicial,
        size: Vector2(15, 15),
        anchor: Anchor.center,
      );

  @override
  Future<void> onLoad() async {
    // Certifique-se que o arquivo bullet.png existe em assets/images/
    sprite = await Sprite.load('bullet.png');
  }

  @override
  void update(double dt) {
    super.update(dt);

    // MELHORIA: Verifica se o alvo ainda está ativo e montado no jogo
    // Se o inimigo foi removido ou está em processo de remoção, a bala some
    if (!alvo.isMounted || alvo.isRemoving) {
      removeFromParent();
      return;
    }

    // Cálculo de direção
    Vector2 direcao = alvo.position - position;

    // Move a bala
    // normalized() evita erros se a distância for zero
    if (direcao.length > 0) {
      position.add(direcao.normalized() * speed * dt);
    }

    // Detecção de colisão por proximidade
    // Aumentei para 15 para garantir o contato visual
    if (position.distanceTo(alvo.position) < 15) {
      alvo.levarDano(dano);
      removeFromParent(); // Remove a bala após o impacto
    }
  }
}
