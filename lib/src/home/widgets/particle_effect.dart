import 'dart:math' show Random;
import 'package:flutter/widgets.dart'
    show
        AnimationController,
        AnimationStatus,
        BuildContext,
        CustomPaint,
        Offset,
        SingleTickerProviderStateMixin,
        Size,
        State,
        StatefulWidget,
        VoidCallback,
        Widget;
import 'package:orangelist/src/home/data/particles.dart' show Particle;
import 'package:orangelist/src/home/widgets/painter/particle_painter.dart'
    show ParticlePainter;
import 'package:orangelist/src/theme/colors.dart' show themeColor;

class ParticleEffect extends StatefulWidget {
  final String text;
  final double width;
  final double height;
  final VoidCallback onComplete;

  const ParticleEffect({
    super.key,
    required this.text,
    required this.width,
    required this.height,
    required this.onComplete,
  });

  @override
  ParticleEffectState createState() => ParticleEffectState();
}

class ParticleEffectState extends State<ParticleEffect>
    with SingleTickerProviderStateMixin {
  List<Particle> particles = [];
  late AnimationController _controller;
  bool completed = false;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _controller.addListener(_updateParticles);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && !completed) {
        completed = status == AnimationStatus.completed;
        widget.onComplete();
      }
    });
    _initParticles();
    _controller.forward();
  }

  void _initParticles() {
    Random random = Random();

    for (int i = 0; i < 100; i++) {
      particles.add(Particle(
        position: Offset(
          random.nextDouble() * widget.width,
          random.nextDouble() * widget.height,
        ),
        color: themeColor,
        size: random.nextDouble() * 8 + 2, // Sets random value between 2 - 10
        velocity: Offset(
          random.nextDouble() * 6 - 3,
          random.nextDouble() * 6 - 3,
          // The offset values goes from -3 to 3 in x and y
        ),
      ));
    }
  }

  void _updateParticles() {
    for (var particle in particles) {
      particle.update();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(widget.width, widget.height),
      painter: ParticlePainter(particles),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
