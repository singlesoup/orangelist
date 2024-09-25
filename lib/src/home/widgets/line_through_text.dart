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
        LayoutBuilder,
        SingleTickerProviderStateMixin,
        SizedBox,
        State,
        StatefulWidget,
        TextDirection,
        TextPainter,
        TextSpan,
        TextStyle,
        Widget,
        WidgetsBinding;
import 'package:orangelist/src/home/widgets/painter/strike_through_painter.dart'
    show StrikeThroughPainter;
import 'package:orangelist/src/theme/colors.dart' show sandAccent;
import 'package:orangelist/src/utils/global_size.dart'
    show GlobalMediaQuerySize;

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
  late TextPainter _textPainter;
  double _textHeight = 0.0;
  double _maxWidth = 0.0;

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

    _textPainter = TextPainter(
      text: TextSpan(
        text: widget.text,
        style: widget.textStyle.copyWith(
          color: widget.isCompleted ? sandAccent.withOpacity(0.56) : sandAccent,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: null,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateTextHeight();
    });
  }

  void _updateTextHeight({String? newText}) {
    if (newText != null) {
      _textPainter = TextPainter(
        text: TextSpan(
          text: newText,
          style: widget.textStyle.copyWith(
            color:
                widget.isCompleted ? sandAccent.withOpacity(0.56) : sandAccent,
          ),
        ),
        textDirection: TextDirection.ltr,
        maxLines: null,
      );
    }
    final globalWidth = GlobalMediaQuerySize.screenWidth ?? 0;
    _textPainter.layout(maxWidth: globalWidth);
    _textHeight = globalWidth > 1300
        ? _textPainter.height * 4.8
        : _textPainter.height * 2.8;
    if (mounted) {
      setState(() {});
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

    if (widget.text != oldWidget.text) {
      _updateTextHeight(newText: widget.text);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // debugPrint(constraints.maxWidth.toString());
        if (_maxWidth != constraints.maxWidth) {
          _maxWidth = constraints.maxWidth;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _updateTextHeight();
          });
        }

        return SizedBox(
          height: _textHeight,
          width: GlobalMediaQuerySize.screenWidth,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return CustomPaint(
                painter: StrikeThroughPainter(
                  progress: _animation.value,
                  strikeColor: widget.strikeColor,
                  text: widget.text,
                  textStyle: widget.textStyle.copyWith(
                    color: widget.isCompleted
                        ? sandAccent.withOpacity(0.56)
                        : sandAccent,
                  ),
                  strokeThickness: 3,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
