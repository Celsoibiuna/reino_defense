import 'package:flame/components.dart';
import 'dart:ui';
import 'enemy.dart';
import 'boss.dart';

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

    final enemies = parent!.children.whereType<Enemy>();
    final bosses = parent!.children.whereType<Boss>();

    for (final enemy in enemies) {
      if (toRect().overlaps(enemy.toRect())) {
        enemy.hit();
        removeFromParent();
      }
    }

    for (final boss in bosses) {
      if (toRect().overlaps(boss.toRect())) {
        boss.hit();
        removeFromParent();
      }
    }

    if (position.x > 900) {
      removeFromParent();
    }
  }
}
