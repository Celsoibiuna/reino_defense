import 'package:flame/components.dart';
import 'reino_game.dart';

class Boss extends SpriteComponent {
  int life = 20;

  Boss() : super(size: Vector2(180, 180), priority: 2);
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('boss.png');
    anchor = Anchor.center;
    print('Boss carregado');
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.x += 25 * dt;

    final game = findGame() as ReinoGame;

    if (life <= 0) {
      game.moedas += 100;
      removeFromParent();
    }

    if (position.x > game.size.x) {
      game.perderVida();
      game.perderVida();
      game.perderVida();
      removeFromParent();
    }
  }

  void hit() {
    life--;
  }
}
