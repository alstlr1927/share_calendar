import 'package:couple_calendar/util/couple_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum ArrowAlign {
  TOP,
  BOTTOM,
}

enum ArrowPosition {
  LEFT,
  CENTER,
  RIGHT,
}

class ProToolTip extends StatelessWidget {
  final ArrowPosition arrowPosition;
  final ArrowAlign arrowAlign;
  final String? text;
  final Color color;
  TextStyle? textStyle;
  final Widget child;

  ProToolTip({
    required this.child,
    this.text,
    this.arrowPosition = ArrowPosition.RIGHT,
    this.arrowAlign = ArrowAlign.TOP,
    this.color = const Color(0xFF212121),
    this.textStyle,
  }) {
    this.textStyle = textStyle ?? TextStyle();
  }

  @override
  Widget build(BuildContext context) {
    Widget arrowWidget = Container();

    switch (arrowPosition) {
      case ArrowPosition.LEFT:
        arrowWidget = Positioned(
          left: 10.toWidth,
          bottom: arrowAlign == ArrowAlign.TOP ? null : 0,
          top: arrowAlign == ArrowAlign.TOP ? 0 : null,
          child: Center(
            child: Container(
              child: RotatedBox(
                quarterTurns: arrowAlign == ArrowAlign.TOP ? 0 : 6,
                child: CustomPaint(
                  painter: DrawArrow(factor: 1, color: color),
                  size: Size(12, 8),
                ),
              ),
            ),
          ),
        );
        break;
      case ArrowPosition.CENTER:
        arrowWidget = Positioned(
          left: 0,
          right: 0,
          bottom: arrowAlign == ArrowAlign.TOP ? null : 0,
          top: arrowAlign == ArrowAlign.TOP ? 0 : null,
          child: Center(
            child: Container(
              child: RotatedBox(
                quarterTurns: arrowAlign == ArrowAlign.TOP ? 0 : 6,
                child: CustomPaint(
                  painter: DrawArrow(factor: 1, color: color),
                  size: Size(12, 8),
                ),
              ),
            ),
          ),
        );
        break;
      case ArrowPosition.RIGHT:
        arrowWidget = Positioned(
          right: 10.toWidth,
          bottom: arrowAlign == ArrowAlign.TOP ? null : 0,
          top: arrowAlign == ArrowAlign.TOP ? 0 : null,
          child: Center(
            child: Container(
              child: RotatedBox(
                quarterTurns: arrowAlign == ArrowAlign.TOP ? 0 : 6,
                child: CustomPaint(
                  painter: DrawArrow(factor: 1, color: color),
                  size: Size(12, 8),
                ),
              ),
            ),
          ),
        );
        break;
    }
    return Stack(
      alignment: Alignment.topRight,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
              top: arrowAlign == ArrowAlign.TOP ? 6.toWidth : 0,
              bottom: arrowAlign == ArrowAlign.BOTTOM ? 6.toWidth : 0),
          constraints: BoxConstraints(minHeight: 36.toWidth),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.toWidth)),
            color: color,
            boxShadow: [
              BoxShadow(
                offset: Offset(2, 4),
                blurRadius: 10,
                color: const Color(0xffd2d5df),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.only(
                left: 12.toWidth,
                right: 12.toWidth,
                top: 8.toWidth,
                bottom: 8.toWidth),
            child: child,
            // child: Row(
            //   mainAxisSize: MainAxisSize.min,
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: <Widget>[
            //     Flexible(
            //       child: Material(
            //         color: Colors.transparent,
            //         child: Text(
            //           '${text}',
            //           style: textStyle,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ),
        ),
        arrowWidget,
      ],
    );
  }
}

class ProCustomToolTip extends StatelessWidget {
  final ArrowAlign arrowAlign;
  final Alignment mainAlign;
  final double absoluteLeft;
  final String? text;
  final Color color;
  TextStyle? textStyle;

  ProCustomToolTip(
      {this.text,
      this.arrowAlign = ArrowAlign.TOP,
      this.absoluteLeft = 0,
      this.color = const Color(0xFF212121),
      this.mainAlign = Alignment.center,
      this.textStyle}) {
    this.textStyle = textStyle ?? TextStyle();
  }

  @override
  Widget build(BuildContext context) {
    Widget arrowWidget = Container();
    arrowWidget = Positioned(
      left: absoluteLeft,
      bottom: arrowAlign == ArrowAlign.TOP ? null : 0,
      top: arrowAlign == ArrowAlign.TOP ? 0 : null,
      child: Center(
        child: Container(
          child: RotatedBox(
            quarterTurns: arrowAlign == ArrowAlign.TOP ? 0 : 6,
            child: CustomPaint(
              painter: DrawArrow(factor: 1, color: color),
              size: Size(12, 8),
            ),
          ),
        ),
      ),
    );

    return Container(
      width: ScreenUtil().screenWidth,
      child: Stack(
        alignment: Alignment.topRight,
        children: <Widget>[
          arrowWidget,
          Align(
            alignment: mainAlign,
            child: Container(
              margin: EdgeInsets.only(
                  top: arrowAlign == ArrowAlign.TOP ? 6.toWidth : 0,
                  bottom: arrowAlign == ArrowAlign.BOTTOM ? 6.toWidth : 0),
              constraints: BoxConstraints(
                  minHeight: 36.toWidth, maxWidth: ScreenUtil().screenWidth),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8.toWidth)),
                color: color,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                    left: 12.toWidth,
                    right: 12.toWidth,
                    top: 8.toWidth,
                    bottom: 8.toWidth),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          '${text}',
                          style: textStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DrawArrow extends CustomPainter {
  Color color;
  late Paint painter;
  double factor;

  DrawArrow({this.factor = 3.0, this.color = const Color(0xFF212121)}) {
    painter = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();

    path.moveTo(size.width / 2 - factor, factor);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width / 2 + factor, factor);
    path.cubicTo(size.width / 2, 0, size.width / 2 - factor, factor,
        size.width / 2 - factor, factor);
    path.close();

    // 그림자 경로 그리기 (살짝 아래로 이동)
    var shadowPaint = Paint()
      ..color = Color(0xffd2d5df).withOpacity(.5)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4.0); // 흐림 효과
    canvas.drawPath(path.shift(Offset(-0, -3)), shadowPaint);

    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
