import 'dart:async';
import 'dart:math';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef CloseCallback = void Function(dynamic value);

enum DisposeDirection {
  UP,
  DOWN,
}

enum PageState { OPEN, CLOSED }

enum AxisEnable { Horizontal, Vertical }

class DragToDispose extends StatelessWidget {
  final Widget Function(ScrollController sc, AnimationController ac)?
      panelBuilder;
  final Widget? header;
  final DragToDisposeController? disposeController;
  final Function? onPageClosed;
  final bool backdropTapClosesPanel;
  double? maxHeight = -1;
  int delay = 500;
  int lastClickTime = 0;
  bool dragEnable = true;

  DragToDispose({
    this.panelBuilder,
    this.backdropTapClosesPanel = false,
    this.header,
    this.onPageClosed,
    this.disposeController,
    this.maxHeight = -1,
    this.dragEnable = true,
  });

  @override
  Widget build(BuildContext context) {
    if (maxHeight!.isNegative) {
      maxHeight = ScreenUtil().screenHeight - ScreenUtil().statusBarHeight - 25;
    }

    return DisposePanel(
      isDraggable: dragEnable,
      header: header,
      maxHeight: maxHeight,
      minHeight: 0.0,
      disposeController: disposeController,
      defaultPageState: PageState.OPEN,
      pageBuilder: (sc, ac) => panelBuilder!(sc!, ac!),
      disposeDirection: DisposeDirection.UP,
      backdropTapClosesPanel: backdropTapClosesPanel,
      onPageClosed: () {
        int now = DateTime.now().millisecondsSinceEpoch;
        if (now - lastClickTime > delay) {
          if (onPageClosed == null) {
            Navigator.maybePop(context);
          } else {
            onPageClosed?.call();
          }
          lastClickTime = now;
        }
      },
      onPageDrag: (double pos) {},
    );
  }
}

class DisposePanel extends StatefulWidget {
  final Widget Function(ScrollController? sc, AnimationController? ac)
      pageBuilder;
  final Widget? header;
  final void Function(double position)? onPageDrag;
  final double minHeight;
  final double? maxHeight;
  final double? snapPoint;
  final bool pageSnapping;
  final bool backdropTapClosesPanel;
  final VoidCallback? onPageOpened;
  final VoidCallback? onPageClosed;
  final bool isDraggable;
  final DisposeDirection disposeDirection;
  final PageState defaultPageState;
  final DragToDisposeController? disposeController;

  DisposePanel(
      {Key? key,
      required this.pageBuilder,
      this.minHeight = 100.0,
      this.maxHeight = 500.0,
      this.snapPoint,
      this.header,
      this.pageSnapping = true,
      this.backdropTapClosesPanel = false,
      this.onPageDrag,
      this.onPageOpened,
      this.onPageClosed,
      this.disposeController,
      this.isDraggable = true,
      this.disposeDirection = DisposeDirection.UP,
      this.defaultPageState = PageState.CLOSED})
      : assert(pageBuilder != null),
        assert(snapPoint == null || 0 < snapPoint && snapPoint < 1.0),
        super(key: key);

  @override
  _DisposePanelState createState() => _DisposePanelState();
}

class _DisposePanelState extends State<DisposePanel>
    with SingleTickerProviderStateMixin, RouteAware {
  AnimationController? _ac;
  ScrollController? _sc;
  double _maxDistance = 0.0;
  AxisEnable? _axisEnable;
  bool _scrollingEnabled = true;
  bool? forceScrollEnable = true;
  VelocityTracker _vt = new VelocityTracker.withKind(PointerDeviceKind.touch);
  bool forceClose = false;
  bool isCurrent = true;
  bool _isPanelVisible = true;
  bool isForceDraggable = false;

  @override
  void dispose() {
    _sc!.removeListener(dragTopListener);
    _sc?.dispose();
    _ac?.dispose();
    BackButtonInterceptor.remove(myInterceptor);

    super.dispose();
  }

  @override
  void didPushNext() {
    isCurrent = false;
  }

  @override
  void didPopNext() {
    isCurrent = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor,
        context: context, name: 'DragToDispose');
    double? startValue =
        widget.defaultPageState == PageState.CLOSED ? 0.0 : 1.0;
    if (widget.snapPoint != null) {
      startValue = widget.snapPoint;
    }
    _ac = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
        value:
            startValue //set the default panel state (i.e. set initial value of _ac)
        )
      ..addListener(() {
        if (widget.onPageDrag != null) widget.onPageDrag!(_ac!.value);

        if (widget.onPageOpened != null && _ac!.value == 1.0) {
          widget.onPageOpened!();
        }

        if (widget.onPageClosed != null && _ac!.value == 0.0) {
          if (isCurrent == false && forceClose == false) {
            _open();
          } else {
            widget.onPageClosed!();
          }
        }
      });

    _sc = ScrollController();
    _sc!.addListener(dragTopListener);
    widget.disposeController?._addState(this);
  }

  dragTopListener() {
    if (_sc?.position.hasListeners ?? false) {
      if (widget.isDraggable && !_scrollingEnabled) {
        _sc!.jumpTo(0);
      }
    }
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (!stopDefaultButtonEvent) {
      if (info.routeWhenAdded!.isCurrent) {
        _close();
      } else {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: widget.disposeDirection == DisposeDirection.UP
          ? Alignment.bottomCenter
          : Alignment.topCenter,
      children: <Widget>[
        if (widget.backdropTapClosesPanel) ...{
          GestureDetector(
            onVerticalDragEnd: (DragEndDetails dets) {
              if ((widget.disposeDirection == DisposeDirection.UP ? 1 : -1) *
                      dets.velocity.pixelsPerSecond.dy >
                  0) _close();
            },
            onTap: widget.backdropTapClosesPanel ? () => _close() : null,
            child: AnimatedBuilder(
                animation: _ac!,
                builder: (context, _) {
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: _ac!.value == 0.0 ? null : Colors.transparent,
                  );
                }),
          ),
        },

        //the actual sliding part
        !_isPanelVisible
            ? Container()
            : AnimatedBuilder(
                animation: _ac!,
                builder: (context, child) {
                  return Container(
                    height:
                        _ac!.value * (widget.maxHeight! - widget.minHeight) +
                            widget.minHeight,
                    child: child,
                  );
                },
                child: Stack(
                  children: <Widget>[
                    //open panel
                    Positioned(
                        top: widget.disposeDirection == DisposeDirection.UP
                            ? 0.0
                            : null,
                        bottom: widget.disposeDirection == DisposeDirection.DOWN
                            ? 0.0
                            : null,
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          height: widget.maxHeight,
                          child: Column(
                            children: [
                              if (widget.header != null) ...{
                                Listener(
                                  onPointerDown: (PointerDownEvent p) {
                                    isForceDraggable = true;
                                    _vt.addPosition(p.timeStamp, p.position);
                                  },
                                  onPointerUp: handlePointerUp,
                                  onPointerMove: handlePointerMove,
                                  child: widget.header,
                                )
                              } else ...{
                                Container()
                              },
                              Flexible(
                                  child: _gestureHandler(
                                      child: widget.pageBuilder(_sc, _ac))!),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
      ],
    );
  }

  void handlePointerMove(PointerMoveEvent event) {
    double _dyDistance = event.delta.dy;
    double _dxDistance = event.delta.dx;
    if (_axisEnable == AxisEnable.Vertical ||
        (_axisEnable == null && _dyDistance.abs() > 0.1)) {
      onScrollVertical(_dyDistance, event);
      return;
    }
    if (_axisEnable == AxisEnable.Horizontal ||
        (_axisEnable == null && _dxDistance.abs() > 0.1)) {
      onScrollHorizontal(_dxDistance, event);
      return;
    }
  }

  void handlePointerUp(PointerUpEvent event) {
    bool isApplyVelocity = _maxDistance.abs() > 8;
    if (isApplyVelocity) {
      int _length = 10;
      for (int i = 0; i < _length; i++) {
        double _distance = _maxDistance / (_length / 2 - (i + 1)).abs();
        Timer(
            Duration(milliseconds: 50 * i),
            () => _axisEnable == AxisEnable.Vertical
                ? onScrollVertical(_distance, event, isScrolling: false)
                : onScrollHorizontal(_distance, event, isScrolling: false));
      }
      Timer(Duration(milliseconds: _length * 50), resetScrollState);
    } else
      resetScrollState();

    _onGestureEnd(_vt.getVelocity());
  }

  void resetScrollState() {
    _axisEnable = null;
    _maxDistance = 0.0;
  }

  void onScrollVertical(double dyDistance, PointerEvent p,
      {bool isScrolling = true}) {
    if (forceScrollEnable == false) {
      return;
    }
    _axisEnable = AxisEnable.Vertical;
    if (dyDistance.abs() > _maxDistance && isScrolling)
      _maxDistance = dyDistance;
    if (p is PointerMoveEvent) {
      _vt.addPosition(p.timeStamp,
          p.position); // add current position for velocity tracking
      _onGestureSlide(p.delta.dy);
    }
  }

  void onScrollHorizontal(double dxDistance, PointerEvent p,
      {bool isScrolling = true}) {
    _axisEnable = AxisEnable.Horizontal;
    if (dxDistance.abs() > _maxDistance && isScrolling)
      _maxDistance = dxDistance;
  }

  Widget? _gestureHandler({Widget? child}) {
    if (!widget.isDraggable) return child;

    return Listener(
      onPointerDown: (PointerDownEvent p) {
        isForceDraggable = false;
        _vt.addPosition(p.timeStamp, p.position);
      },
      onPointerUp: handlePointerUp,
      onPointerMove: handlePointerMove,
      child: child,
    );
  }

  // handles the sliding gesture
  void _onGestureSlide(double dy) {
    // only slide the panel if scrolling is not enabled

    if (_ac!.value != 1.0) {
      if (_sc!.hasClients && _sc!.offset == 0.0) {
        if (_scrollingEnabled != false) {
          setState(() {
            _scrollingEnabled = false;
          });
        }
      }
    } else {
      if (_sc!.hasClients && _sc!.offset <= 0) {
        if (dy < 0) {
          if (_scrollingEnabled != true) {
            setState(() {
              _scrollingEnabled = true;
            });
          }
        } else {
          if (_scrollingEnabled != false) {
            setState(() {
              _scrollingEnabled = false;
            });
          }
        }
      } else {
        if (_scrollingEnabled != true) {
          setState(() {
            _scrollingEnabled = true;
          });
        }
      }
    }

    if (isForceDraggable) {
      if (widget.disposeDirection == DisposeDirection.UP)
        _ac!.value -= dy / (widget.maxHeight! - widget.minHeight);
      else
        _ac!.value += dy / (widget.maxHeight! - widget.minHeight);
    } else {
      if (!_scrollingEnabled) {
        if (widget.disposeDirection == DisposeDirection.UP)
          _ac!.value -= dy / (widget.maxHeight! - widget.minHeight);
        else
          _ac!.value += dy / (widget.maxHeight! - widget.minHeight);
      }
    }
  }

  // handles when user stops sliding
  void _onGestureEnd(Velocity v) {
    double minFlingVelocity = 365.0;
    double kSnap = 8;

    if (_ac == null) return;

    //let the current animation finish before starting a new one
    if (_ac!.isAnimating) return;

    // if scrolling is allowed and the panel is open, we don't want to close
    // the panel if they swipe up on the scrollable
    if (_isPanelOpen && _scrollingEnabled) return;

    //check if the velocity is sufficient to constitute fling to end
    double visualVelocity =
        -v.pixelsPerSecond.dy / (widget.maxHeight! - widget.minHeight);

    // reverse visual velocity to account for slide direction
    if (widget.disposeDirection == DisposeDirection.DOWN)
      visualVelocity = -visualVelocity;

    // get minimum distances to figure out where the panel is at
    double d2Close = _ac!.value;
    double d2Open = 1 - _ac!.value;
    double d2Snap = ((widget.snapPoint ?? 3) - _ac!.value)
        .abs(); // large value if null results in not every being the min

    double minDistance = min(d2Close, min(d2Snap, d2Open));

    // check if velocity is sufficient for a fling
    if (v.pixelsPerSecond.dy.abs() >= minFlingVelocity) {
      // snapPoint exists
      if (widget.pageSnapping && widget.snapPoint != null) {
        if (v.pixelsPerSecond.dy.abs() >= kSnap * minFlingVelocity ||
            minDistance == d2Snap) {
          _ac!.fling(velocity: visualVelocity);
        } else {
          _flingPanelToPosition(widget.snapPoint!, visualVelocity);
        }

        // no snap point exists
      } else if (widget.pageSnapping) {
        _ac!.fling(velocity: visualVelocity);

        // panel snapping disabled
      } else {
        _ac!.animateTo(
          _ac!.value + visualVelocity * 0.16,
          duration: Duration(milliseconds: 410),
          curve: Curves.decelerate,
        );
      }

      return;
    }

    // check if the controller is already halfway there
    if (widget.pageSnapping) {
      if (d2Close < 0.2) {
        _close();
      } else if (minDistance == d2Snap) {
        _flingPanelToPosition(widget.snapPoint!, visualVelocity);
      } else {
        _open();
      }
    }
  }

  void _flingPanelToPosition(double targetPos, double velocity) {
    final Simulation simulation = SpringSimulation(
        SpringDescription.withDampingRatio(
          mass: 1.0,
          stiffness: 500.0,
          ratio: 1.0,
        ),
        _ac!.value,
        targetPos,
        velocity);

    _ac!.animateWith(simulation);
  }

  //---------------------------------
  //PanelController related functions
  //---------------------------------

  //close the panel
  Future<void>? _close() {
    return _ac?.fling(velocity: -1.0);
  }

  //close the panel
  Future<void>? _forceClose() {
    return _ac?.fling(velocity: -1.0);
  }

  //open the panel
  Future<void>? _open() {
    return _ac?.fling(velocity: 1.0);
  }

  //returns whether or not the
  //panel is open
  bool get _isPanelOpen => _ac!.value == 1.0;

  setForceAvoidScroll({bool? isEnable}) {
    if (forceScrollEnable != isEnable) {
      setState(() {
        forceScrollEnable = isEnable;
      });
    }
  }
}

class DragToDisposeController {
  late _DisposePanelState _panelState;

  void _addState(_DisposePanelState panelState) {
    _panelState = panelState;
  }

  setScrollEnable({bool isEnable = true}) {
    _panelState.setForceAvoidScroll(isEnable: isEnable);
  }

  close() {
    _panelState._forceClose();
  }
}
