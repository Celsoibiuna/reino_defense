import 'package:flame/components.dart';
import 'dart:ui';
import 'bullet.dart';

class Tower extends RectangleComponent {
  double timer = 0;

  Tower()
    : super(
        size: Vector2(50, 50),
        paint: Paint()..color = const Color(0xFF00FF00),
      );

  @override
  void update(double dt) {
    super.update(dt);

    timer += dt;

    if (timer > 1) {
      timer = 0;

      parent?.add(
        Bullet()..position = Vector2(position.x + 40, position.y + 15),
      );
    }
  }
}
