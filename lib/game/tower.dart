import 'package:flame/components.dart';
import 'bullet.dart';

class Tower extends SpriteComponent {
  double timer = 0;
  double fireRate = 1.0;
  int level = 1;

  Tower() : super(size: Vector2(150, 150), priority: 3);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('tower.png');
    anchor = Anchor.center;
    print('Tower carregada');
  }

  @override
  void update(double dt) {
    super.update(dt);

    timer += dt;

    if (timer >= fireRate) {
      timer = 0;

      parent?.add(
        Bullet()..position = Vector2(position.x + 50, position.y + 20),
      );
    }
  }

  void upgrade() {
    if (level < 5) {
      level++;
      fireRate *= 0.8;
      size += Vector2(5, 5);
    }
  }
}
