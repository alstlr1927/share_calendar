import 'package:couple_calendar/util/couple_style.dart';
import 'package:couple_calendar/util/couple_util.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';

class InsetShadowBox extends StatelessWidget {
  final Widget child;
  final Color color;

  const InsetShadowBox({
    super.key,
    required this.child,
    this.color = CoupleStyle.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.toWidth),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: CoupleStyle.black.withOpacity(.03),
            blurRadius: 12,
            inset: true,
          ),
          BoxShadow(
            offset: Offset(0, 2.31),
            color: CoupleStyle.black.withOpacity(.1),
            blurRadius: 8,
            inset: true,
          ),
        ],
      ),
      child: child,
    );
  }
}
