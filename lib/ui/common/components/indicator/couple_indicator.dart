import 'dart:math' as math;

import 'package:flutter/material.dart';

const double _kDefaultIndicatorRadius = 10.0;
const Color _kActiveTickColor = Color(0xFF3C3C44);

class CoupleIndicator extends StatefulWidget {
  final bool animating;
  final bool isMaterial;
  final Color? color;

  double radius;

  CoupleIndicator({
    Key? key,
    this.animating = true,
    this.isMaterial = false,
    this.color,
    this.radius = _kDefaultIndicatorRadius,
  })  : assert(animating != null),
        assert(radius != null),
        assert(radius > 0),
        super(key: key);

  @override
  State<CoupleIndicator> createState() => _CoupleIndicatorState();
}

class _CoupleIndicatorState extends State<CoupleIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    if (widget.animating) _controller!.repeat();
  }

  @override
  void didUpdateWidget(covariant CoupleIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animating != oldWidget.animating) {
      if (widget.animating) {
        _controller!.repeat();
      } else {
        _controller!.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isMaterial) {
      return Center(
        child: Container(
          width: widget.radius * 2,
          height: widget.radius * 2,
          child: Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: CircularProgressIndicator(
                strokeWidth: .7,
                valueColor: AlwaysStoppedAnimation<Color>(
                  widget.color ?? Colors.grey,
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Center(
        child: SizedBox(
          height: widget.radius * 2,
          width: widget.radius * 2,
          child: RepaintBoundary(
            key: Key(''),
            child: CustomPaint(
              painter: _CupertinoActivityIndicatorPainter(
                position: _controller,
                activeColor: widget.color ?? _kActiveTickColor,
                radius: widget.radius,
              ),
            ),
          ),
        ),
      );
    }
  }
}

const double _kTwoPI = math.pi * 2.0;
const int _kTickCount = 12;

// Alpha values extracted from the native component (for both dark and light mode).
// The list has a length of 12.
const List<int> _alphaValues = <int>[
  147,
  131,
  114,
  97,
  81,
  64,
  47,
  47,
  47,
  47,
  47,
  47
];

class _CupertinoActivityIndicatorPainter extends CustomPainter {
  _CupertinoActivityIndicatorPainter({
    required this.position,
    required this.activeColor,
    required double radius,
  })  : tickFundamentalRRect = RRect.fromLTRBXY(
          -radius,
          radius / _kDefaultIndicatorRadius,
          -radius / 2.0,
          -radius / _kDefaultIndicatorRadius,
          radius / _kDefaultIndicatorRadius,
          radius / _kDefaultIndicatorRadius,
        ),
        super(repaint: position);

  final Animation<double>? position;
  final RRect tickFundamentalRRect;
  final Color? activeColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();

    canvas.save();
    canvas.translate(size.width / 2.0, size.height / 2.0);

    final int activeTick = (_kTickCount * position!.value).floor();

    for (int i = 0; i < _kTickCount; ++i) {
      final int t = (i + activeTick) % _kTickCount;
      paint.color = activeColor!.withAlpha(_alphaValues[t]);
      canvas.drawRRect(tickFundamentalRRect, paint);
      canvas.rotate(-_kTwoPI / _kTickCount);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_CupertinoActivityIndicatorPainter oldPainter) {
    return oldPainter.position != position ||
        oldPainter.activeColor != activeColor;
  }
}
