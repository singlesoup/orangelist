import 'package:flutter/widgets.dart'
    show
        AnimatedBuilder,
        Animation,
        AnimationController,
        BuildContext,
        Color,
        Curve,
        CurvedAnimation,
        CustomPaint,
        SingleTickerProviderStateMixin,
        State,
        StatefulWidget,
        TextStyle,
        Widget;
import 'package:orangelist/src/home/widgets/painter/strike_through_painter.dart'
    show StrikeThroughPainter;
import 'package:orangelist/src/theme/colors.dart' show sandAccent;

class LineThroughText extends StatefulWidget {
  const LineThroughText({
    super.key,
    required this.text,
    required this.duration,
    this.strikeColor = sandAccent,
    required this.textStyle,
    required this.isCompleted,
    required this.curve,
  });

  final String text;
  final Duration duration;
  final Color strikeColor;
  final TextStyle textStyle;
  final bool isCompleted;
  final Curve curve;

  @override
  State<LineThroughText> createState() => _LineThroughTextState();
}

class _LineThroughTextState extends State<LineThroughText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    if (widget.isCompleted) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant LineThroughText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCompleted != oldWidget.isCompleted) {
      if (widget.isCompleted) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: StrikeThroughPainter(
            progress: _animation.value,
            strikeColor: widget.strikeColor,
            text: widget.text,
            textStyle: widget.textStyle,
            strokeThickness: 3,
          ),
        );
      },
    );
  }
}
