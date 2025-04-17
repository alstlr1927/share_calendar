import 'package:flutter/material.dart';

class LazyIndexedStack extends StatefulWidget {
  final int index;
  final List<Widget> children;
  final AlignmentGeometry alignment;
  final TextDirection? textDirection;
  final StackFit sizing;
  final bool isFadeAnimation;
  const LazyIndexedStack({
    Key? key,
    required this.index,
    required this.children,
    this.alignment = AlignmentDirectional.topStart,
    this.textDirection,
    this.sizing = StackFit.loose,
    this.isFadeAnimation = false,
  })  : assert(index != null),
        assert(children != null),
        super(key: key);

  @override
  State<LazyIndexedStack> createState() => _LazyIndexedStackState();
}

class _LazyIndexedStackState extends State<LazyIndexedStack> {
  late Map<int?, bool> innerWidgetMap;

  int? index;

  @override
  void initState() {
    super.initState();
    index = widget.index;
    innerWidgetMap = Map<int?, bool>.fromEntries(
      List<MapEntry<int, bool>>.generate(
        widget.children.length,
        (int i) => MapEntry<int, bool>(i, i == index),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant LazyIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) {
      _changeIndex(widget.index);
    }
  }

  void _activeCurrentIndex(int? index) {
    if (innerWidgetMap[index] != true) {
      innerWidgetMap[index] = true;
    }
  }

  void _changeIndex(int value) {
    if (value == index) {
      return;
    }
    setState(() {
      index = value;
    });
  }

  bool _hasInit(int index) {
    final bool? result = innerWidgetMap[index];
    if (result == null) {
      return false;
    }
    return result == true;
  }

  List<Widget> _buildChildren(BuildContext context) {
    final List<Widget> list = <Widget>[];
    for (int i = 0; i < widget.children.length; i++) {
      if (_hasInit(i)) {
        list.add(widget.children[i]);
      } else {
        list.add(const SizedBox.shrink());
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    _activeCurrentIndex(index);

    if (widget.isFadeAnimation) {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: IndexedStack(
          key: ValueKey<int>(index!),
          index: index,
          alignment: widget.alignment,
          sizing: widget.sizing,
          textDirection: widget.textDirection,
          children: _buildChildren(context),
        ),
      );
    }
    return IndexedStack(
      index: index,
      alignment: widget.alignment,
      sizing: widget.sizing,
      textDirection: widget.textDirection,
      children: _buildChildren(context),
    );
  }
}
