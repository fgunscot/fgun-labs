import 'package:flutter/material.dart';

class IntroOverlay extends StatefulWidget {
  const IntroOverlay({Key? key}) : super(key: key);

  @override
  State<IntroOverlay> createState() => _IntroOverlayState();
}

class _IntroOverlayState extends State<IntroOverlay>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isForward = true;
  final Duration _duration = const Duration(milliseconds: 1500);
  final double startRad = 900.0;
  double targetRad = 52.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration);
    _animation =
        Tween<double>(begin: startRad, end: targetRad).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, anim) {
        return GestureDetector(
          onTap: () => setState(() {
            isForward = !isForward;
            isForward ? _controller.forward() : _controller.reverse();
          }),
          child: ClipShadowPath(
            clipper: InvertedClipper(_animation.value),
            shadow: const Shadow(blurRadius: 5),
            child: Container(
              color: Colors.blue,
              child: Center(child: Text(_animation.value.toString())),
            ),
          ),
        );
      },
    );
  }
}

class InvertedClipper extends CustomClipper<Path> {
  const InvertedClipper(this.circleSize);
  final double circleSize;
  @override
  Path getClip(Size size) {
    return Path.combine(
      PathOperation.difference,
      Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
      Path()
        ..addOval(Rect.fromCircle(
            center: Offset(size.width - 18, 28), radius: circleSize))
        ..close(),
    );
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

@immutable
class ClipShadowPath extends StatelessWidget {
  final Shadow shadow;
  final CustomClipper<Path> clipper;
  final Widget child;

  const ClipShadowPath({
    Key? key,
    required this.shadow,
    required this.clipper,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      key: UniqueKey(),
      painter: _ClipShadowShadowPainter(
        clipper: clipper,
        shadow: shadow,
      ),
      child: ClipPath(child: child, clipper: clipper),
    );
  }
}

class _ClipShadowShadowPainter extends CustomPainter {
  final Shadow shadow;
  final CustomClipper<Path> clipper;

  _ClipShadowShadowPainter({required this.shadow, required this.clipper});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = shadow.toPaint();
    var clipPath = clipper.getClip(size).shift(shadow.offset);
    canvas.drawPath(clipPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
