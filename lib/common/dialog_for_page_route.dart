import 'dart:math' as math;

import 'package:flutter/material.dart';

class _Const {
  _Const._();

  static const double maxWidth = 600;
  static const double borderRadius = 20;
  static const double minHPadding = 16;
  static const double minVPadding = 16;
  static const Duration transitionDuration = Duration(milliseconds: 500);
  static const Curve transitionCurve = Curves.fastOutSlowIn;
  static const Duration reverseTransitionDuration = Duration(milliseconds: 300);
  static const Curve reverseTransitionCurve =
      FlippedCurve(Curves.fastOutSlowIn);
}

class DialogForPageRoute<T> extends PageRoute<T> {
  DialogForPageRoute({
    required this.builder,
    this.barrierDismissible = false,
  }) : super();

  final WidgetBuilder builder;

  @override
  bool get opaque => false;

  @override
  final bool barrierDismissible;

  @override
  Duration get transitionDuration => _Const.transitionDuration;

  @override
  Duration get reverseTransitionDuration => _Const.reverseTransitionDuration;

  @override
  bool get maintainState => true;

  @override
  Color? get barrierColor => Colors.black54;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: _Const.transitionCurve,
      reverseCurve: _Const.reverseTransitionCurve,
    );

    return FadeTransition(
      opacity: curvedAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(curvedAnimation),
        child: child,
      ),
    );
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) =>
      _DialogForPageRouteContainer(builder);
}

class _DialogForPageRouteContainer extends StatefulWidget {
  const _DialogForPageRouteContainer(this.builder);

  final WidgetBuilder builder;

  @override
  State<_DialogForPageRouteContainer> createState() =>
      _DialogForPageRouteContainerState();
}

class _DialogForPageRouteContainerState
    extends State<_DialogForPageRouteContainer> {
  double _offset = 0;

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    final safeAreaPadding = mediaQueryData.padding;
    final minTop = safeAreaPadding.top + _Const.minVPadding;
    final minBottom = safeAreaPadding.bottom + _Const.minVPadding;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: _Const.minHPadding),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: _Const.maxWidth,
          ),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: AnimatedContainer(
                  height: minTop + _offset,
                  duration: const Duration(milliseconds: 200),
                ),
              ),
              SliverToBoxAdapter(
                child: MediaQuery(
                  data: mediaQueryData.removePadding(
                    removeTop: true,
                    removeBottom: true,
                  ),
                  child: Material(
                    clipBehavior: Clip.antiAlias,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(_Const.borderRadius),
                    ),
                    child: widget.builder(context),
                  ),
                ),
              ),
              SliverLayoutBuilder(
                builder: (context, constraints) {
                  final bottomOffset = constraints.viewportMainAxisExtent -
                      constraints.precedingScrollExtent -
                      minBottom;

                  if (_offset != bottomOffset) {
                    _offset = math.max((bottomOffset + _offset) / 2, 0);
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      setState(() {});
                    });
                  }

                  return const SliverToBoxAdapter(
                    child: SizedBox.shrink(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
