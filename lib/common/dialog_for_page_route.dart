import 'package:flutter/material.dart';

class _Const {
  _Const._();

  static const double maxWidth = 600;
  static const double borderRadius = 20;
  static const EdgeInsetsGeometry minPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 16);
  static const Duration transitionDuration = Duration(milliseconds: 300);
  static const Curve transitionCurve = Curves.fastOutSlowIn;
  static const Duration reverseTransitionDuration = Duration(milliseconds: 300);
  static const Curve reverseTransitionCurve =
      FlippedCurve(Curves.fastOutSlowIn);
}

class DialogForPageRoute<T> extends PageRoute<T> {
  final WidgetBuilder builder;
  @override
  bool get opaque => false;
  @override
  final bool barrierDismissible;

  DialogForPageRoute({
    required this.builder,
    this.barrierDismissible = false,
  }) : super();

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
  Widget buildTransitions(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) =>
      SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: _Const.transitionCurve,
            reverseCurve: _Const.reverseTransitionCurve,
          ),
        ),
        child: child,
      );

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
      Padding(
        padding: _Const.minPadding,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: _Const.maxWidth,
            ),
            child: SafeArea(
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
      );
}
