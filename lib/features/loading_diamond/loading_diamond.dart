import 'package:flutter/material.dart';

class DiamondLoading extends StatefulWidget {
  @override
  _DiamondLoadingState createState() => _DiamondLoadingState();
}

class _DiamondLoadingState extends State<DiamondLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: CustomPaint(
        painter: DiamondPainter(),
        size: Size(80, 80),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class DiamondPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    double halfWidth = size.width / 2;
    double halfHeight = size.height / 2;

    Path path = Path()
      ..moveTo(halfWidth, 0)
      ..lineTo(size.width, halfHeight)
      ..lineTo(halfWidth, size.height)
      ..lineTo(0, halfHeight)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
