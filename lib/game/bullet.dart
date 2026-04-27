import 'package:flame/components.dart';
import 'dart:ui';

class Bullet extends RectangleComponent {
  Bullet()
    : super(
        size: Vector2(15, 15),
        paint: Paint()..color = const Color(0xFFFFFF00),
      );

  @override
  void update(double dt) {
    super.update(dt);

    position.x += 250 * dt;

    if (position.x > 800) {
      removeFromParent();
    }
  }
}
