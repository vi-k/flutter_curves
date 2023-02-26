import 'package:flutter/material.dart';

class DialogForPageRoute<T> extends PageRoute<T> {
  static Curve transitionCurve = Curves.easeOutBack;

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
  Duration get transitionDuration => const Duration(milliseconds: 500);
  // Duration get transitionDuration => const Duration(milliseconds: 2000);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 300);
  // Duration get reverseTransitionDuration => const Duration(milliseconds: 2000);

  @override
  bool get maintainState => true;

  @override
  Color? get barrierColor => Colors.black54;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) =>
      // ScaleTransition(
      //   scale: CurvedAnimation(
      //     parent: animation,
      //     curve: transitionCurve,
      //     reverseCurve: Curves.linearToEaseOut.flipped,
      //   ),
      //   child: child,
      // );
      SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: transitionCurve,
            reverseCurve: transitionCurve.flipped,
          ),
        ),
        child: child,
      );

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Material(
              clipBehavior: Clip.antiAlias,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: builder(context),
            ),
          ),
        ),
      );
}
