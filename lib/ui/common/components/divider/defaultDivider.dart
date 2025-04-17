import 'package:couple_calendar/util/couple_style.dart';
import 'package:flutter/material.dart';

class DefaultDivider extends StatelessWidget {
  const DefaultDivider({
    Key? key,
    this.height = 0,
    this.indent,
    this.endIndent,
  })  : assert(height == null || height >= 0.0),
        assert(indent == null || indent >= 0.0),
        assert(endIndent == null || endIndent >= 0.0),
        super(key: key);

  final double height;
  final double? indent;
  final double? endIndent;

  @override
  Widget build(BuildContext context) {
    return Divider(
        height: height,
        color: CoupleStyle.gray040,
        endIndent: endIndent,
        indent: indent,
        thickness: 1);
  }
}
