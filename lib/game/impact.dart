import 'package:flame/components.dart';
import 'dart:ui';

class Impact extends CircleComponent {
  double timer = 0;

  Impact(Vector2 position)
    : super(
        position: position,
        radius: 10,
        anchor: Anchor.center,
        paint: Paint()..color = const Color(0xFFFFAA00),
      );

  @override
  void update(double dt) {
    super.update(dt);

    timer += dt;

    // aumenta e some
    radius += 40 * dt;
    paint.color = paint.color.withOpacity(1 - timer);

    if (timer > 0.3) {
      removeFromParent();
    }
  }
}
