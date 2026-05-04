import 'package:flame/components.dart';
import 'package:flutter/material.dart'; // Use material para ter acesso a mais recursos de cor

class Impact extends CircleComponent {
  double timer = 0;
  final double duracao = 0.3; // Definimos a duração como constante

  Impact(Vector2 position)
    : super(
        position: position,
        radius: 5, // Começa menor para o efeito de expansão ser mais visível
        anchor: Anchor.center,
        paint: Paint()..color = const Color(0xFFFFAA00),
      );

  @override
  void update(double dt) {
    super.update(dt);

    timer += dt;

    // 1. Expansão do círculo
    radius += 100 * dt;

    // 2. Cálculo de Opacidade Seguro
    // clamp(0.0, 1.0) garante que o valor nunca seja negativo
    double opacidade = (1.0 - (timer / duracao)).clamp(0.0, 1.0);
    paint.color = paint.color.withOpacity(opacidade);

    // 3. Remoção
    if (timer >= duracao) {
      removeFromParent();
    }
  }
}
