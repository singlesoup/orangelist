import 'package:flutter/widgets.dart' show Offset, Color;

class Particle {
  Offset position;
  Color color;
  double size;
  Offset velocity;

  Particle({
    required this.position,
    required this.color,
    required this.size,
    required this.velocity,
  });

  void update() {
    position += velocity;
    size *= 0.95; // Shrink the particle
  }
}
