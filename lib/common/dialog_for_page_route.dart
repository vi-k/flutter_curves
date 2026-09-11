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
  static const Curve reverseTransitionCurve = FlippedCurve(
    Curves.fastOutSlowIn,
  );
}

class DialogForPageRoute<T> extends PageRoute<T> {
  DialogForPageRoute({required this.builder, this.barrierDismissible = false})
    : super();

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
  ) => _DialogForPageRouteContainer(builder);
}

/// The frame the dialog sits in: safe-area insets, a width cap and a scroll
/// view no taller than its content.
///
/// The scroll view must not cover the viewport. `Scrollable` hit-tests
/// opaquely, so everything underneath it — the modal barrier included — stops
/// receiving taps; the empty room above and below the dialog therefore belongs
/// to [Center], not to the scroll view.
class _DialogForPageRouteContainer extends StatelessWidget {
  const _DialogForPageRouteContainer(this.builder);

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    final safeAreaPadding = mediaQueryData.padding;

    return Padding(
      padding: EdgeInsets.only(
        top: safeAreaPadding.top + _Const.minVPadding,
        bottom: safeAreaPadding.bottom + _Const.minVPadding,
        left: _Const.minHPadding,
        right: _Const.minHPadding,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _Const.maxWidth),
          child: SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
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
                  child: builder(context),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
