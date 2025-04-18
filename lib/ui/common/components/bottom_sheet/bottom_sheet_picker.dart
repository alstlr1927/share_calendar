import 'package:couple_calendar/util/couple_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../../../../util/couple_style.dart';
import '../divider/defaultDivider.dart';
import 'theme/bottom_sheet_theme.dart';

/// [BottomSheetItem] 모델
class BottomSheetItem {
  final String? title;
  final bool? cautionFlag;
  final VoidCallback? onPressed;

  BottomSheetItem({this.title, this.cautionFlag, this.onPressed});
}

/// [BottomSheetPicker] 기본으로 사용되는 바텀시트
///
class BottomSheetPicker extends StatefulWidget {
  final int? selectedIndex;
  final List<BottomSheetItem>? actions;
  final BottomSheetItem? cancelItem;

  BottomSheetPicker({this.actions, this.cancelItem, this.selectedIndex});

  @override
  _BottomSheetPickerState createState() => _BottomSheetPickerState();
}

class _BottomSheetPickerState extends State<BottomSheetPicker> {
  late List<bool> tapDown;
  bool cancelItemTapDown = false;

  @override
  void initState() {
    tapDown = List.generate(widget.actions!.length, (i) => false);
    super.initState();
  }

  GlobalKey keys = GlobalKey();

  final Set<int?> selectedIndexes = Set<int?>();
  final Set<BaseRendererProxy> _trackTaped = Set<BaseRendererProxy>();

  _detectTapedItem(PointerEvent event) {
    final RenderBox box = keys.currentContext!.findRenderObject() as RenderBox;
    final result = BoxHitTestResult();
    Offset local = box.globalToLocal(event.position);
    if (box.hitTest(result, position: local)) {
      for (final hit in result.path) {
        /// temporary variable so that the [is] allows access of [index]
        final target = hit.target;
        if (target is BaseRendererProxy) {
          _trackTaped.add(target);
          _selectIndex(target.index);
        }
      }
    }
  }

  _selectIndex(int? index) {
    if (selectedIndexes.contains(index)) {
      return;
    } else {
      setState(() {
        HapticFeedback.selectionClick();
        selectedIndexes.clear();
        selectedIndexes.add(index);
      });
    }
  }

  void _clearSelection(PointerUpEvent event) async {
    _trackTaped.clear();
    if (mounted) {
      setState(() {
        selectedIndexes.clear();
      });
    }

    final RenderBox box = keys.currentContext!.findRenderObject() as RenderBox;
    final result = BoxHitTestResult();
    Offset local = box.globalToLocal(event.position);
    if (box.hitTest(result, position: local)) {
      for (final hit in result.path) {
        /// temporary variable so that the [is] allows access of [index]
        final target = hit.target;
        if (target is BaseRendererProxy) {
          if (target.index!.isNegative) {
            Navigator.pop(context);
            if (widget.cancelItem?.onPressed != null) {
              widget.cancelItem?.onPressed!();
            }
          } else {
            Navigator.pop(context);
            if (widget.actions![target.index!].onPressed != null) {
              widget.actions![target.index!].onPressed!();
            }
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(
            left: 16, right: 16, bottom: CoupleStyle.defaultBottomPadding()),
        child: Listener(
          onPointerDown: _detectTapedItem,
          onPointerMove: _detectTapedItem,
          onPointerUp: _clearSelection,
          child: Column(
            key: keys,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: CoupleStyle.elevation_8dp(),
                ),
                child: ClipRRect(
                  clipBehavior: Clip.antiAlias,
                  borderRadius: BorderRadius.circular(8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          for (int i = 0; i < widget.actions!.length; i++) ...{
                            if (tapDown.length == widget.actions!.length) ...{
                              BaseRenderer(
                                index: i,
                                child: buildItem(i),
                              ),
                              if (i != widget.actions!.length - 1) ...{
                                const DefaultDivider(height: 0),
                              }
                            } else ...{
                              Container()
                            }
                          }
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (widget.cancelItem != null) ...{
                SizedBox(height: 8.toWidth),
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: CoupleStyle.elevation_8dp(),
                    ),
                    child: ClipRRect(
                        clipBehavior: Clip.antiAlias,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: CoupleStyle.elevation_8dp(),
                            color: Colors.white,
                          ),
                          child:
                              BaseRenderer(index: -1, child: buildCancelItem()),
                        )))
              },
            ],
          ),
        ),
      ),
    );
  }

  /// [buildItem] 기본으로 사용되는 바텀시트아이템, 체크되었을때 표시
  buildItem(index) {
    if (widget.actions![index].title == '') {
      return SizedBox();
    }

    return Container(
      color: selectedIndexes.contains(index)
          ? BottomSheetThemeColor.sheet_pressed_base_gray
          : BottomSheetThemeColor.sheet_base_white,
      height: 46.toWidth,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Container(
                child: Align(
              alignment: Alignment.center,
              child: Text('${widget.actions![index].title}',
                  textAlign: TextAlign.center,
                  style: CoupleStyle.body2(
                      color: widget.actions![index].cautionFlag == true
                          ? CoupleStyle.coral050
                          : CoupleStyle.gray090)),
            )),
          ),
        ],
      ),
    );
  }

  buildCancelItem() {
    if (widget.cancelItem!.title == '') {
      return SizedBox();
    }
    return Container(
      height: 46.toWidth,
      color: selectedIndexes.contains(-1)
          ? BottomSheetThemeColor.sheet_pressed_base_gray
          : BottomSheetThemeColor.sheet_base_white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Container(
                child: Align(
              alignment: Alignment.center,
              child: Text('${widget.cancelItem!.title}',
                  textAlign: TextAlign.center,
                  style: CoupleStyle.body2(
                      color: CoupleStyle.gray070, weight: FontWeight.w600)),
            )),
          ),
        ],
      ),
    );
  }
}

class BaseRenderer extends SingleChildRenderObjectWidget {
  final int? index;

  BaseRenderer({Widget? child, this.index, Key? key})
      : super(child: child, key: key);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return BaseRendererProxy()..index = index;
  }

  @override
  void updateRenderObject(
      BuildContext context, BaseRendererProxy renderObject) {
    renderObject..index = index;
  }
}

class BaseRendererProxy extends RenderProxyBox {
  int? index;
}
