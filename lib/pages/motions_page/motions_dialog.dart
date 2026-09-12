import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:scopo/scopo.dart';

import '../../constants.dart';
import '../../motions/export.dart';
import '../home_page/home_scope.dart';

const double _boxSize = 60;
const double _selectionPadding = 3;
const double _selectionWidth = 2;

/// The scope of the motion picker.
///
/// [parent] arrives as a parameter rather than through the tree: the picker is
/// a route of its own, so the home scope is not above it.
final class MotionsDialog extends LiteScope<MotionsDialog, MotionsDialogState> {
  const MotionsDialog({
    super.key,
    required this.parent,
    required this.animation,
    this.selectedMotion,
    this.selectedHeroTag,
  }) : assert(
         selectedMotion == null && selectedHeroTag == null ||
             selectedMotion != null && selectedHeroTag != null,
         'Both selected and selectedHeroTag must be set',
       );

  final HomeScopeState parent;
  final Animation<double> animation;
  final MotionObject? selectedMotion;
  final String? selectedHeroTag;

  /// The type arguments of this scope, named once.
  static const access = LiteScopeAccess<MotionsDialog, MotionsDialogState>();

  @override
  Widget? buildOnWaiting(BuildContext context) => const SizedBox.shrink();

  @override
  MotionsDialogState createState() => MotionsDialogState();
}

/// The state of the motion picker.
final class MotionsDialogState
    extends LiteScopeState<MotionsDialog, MotionsDialogState> {
  /// Templates that have already been given the hero tag in this build.
  ///
  /// The same template may appear in several rows, and only the first of them
  /// may fly: two heroes with one tag is an error. Cleared by [build], filled
  /// by the rows it builds.
  final Set<MotionObject> alreadyOnList = {};

  late MotionObject? _selectedMotion = params.selectedMotion;

  MotionObject? get selectedMotion => _selectedMotion;

  void select(MotionObject value) {
    setState(() {
      _selectedMotion = value;
    });
    notifyDependents();

    if (mounted) Navigator.pop(context, value);
  }

  @override
  Widget build(BuildContext context) {
    alreadyOnList.clear();

    return Column(
      children: [
        const _Title(),
        _ClassRow<TranslateTransformer>('Translate', motionsTemplates),
        const SizedBox(height: Const.defaultPadding),
        _ClassRow<ScaleTransformer>('Scale', motionsTemplates),
        const SizedBox(height: Const.defaultPadding),
        _ClassRow<RotateTransformer>('Rotate', motionsTemplates),
        const SizedBox(height: Const.defaultPadding),
        _ClassRow<SkewTransformer>('Skew', motionsTemplates),
        const SizedBox(height: Const.defaultPadding),
        _ClassRow<FadeTransformer>('Fade', motionsTemplates),
        const SizedBox(height: Const.defaultPadding),
        _ClassRow<ColorTransformer>('Color', motionsTemplates),
        const SizedBox(height: Const.defaultPadding),
        _ClassRow<BorderRadiusTransformer>('BorderRadius', motionsTemplates),
        const SizedBox(height: Const.defaultPadding),
        _ClassRow<MatrixTransformer>('Matrix', motionsTemplates),
        const SizedBox(height: 2 * Const.defaultPadding),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) =>
      AppBar(title: const Text('Select a motion'));
}

class _ClassRow<T extends MotionTransformer<Object?>> extends StatefulWidget {
  const _ClassRow(this.name, this.templates);

  final String name;
  final IList<MotionObject> templates;

  @override
  State<_ClassRow<T>> createState() => _ClassRowState<T>();
}

class _ClassRowState<T extends MotionTransformer<Object?>>
    extends State<_ClassRow<T>> {
  late IList<MotionObject> _filteredTemplates;

  @override
  void initState() {
    super.initState();

    _filteredTemplates = widget.templates
        .where((e) => e.transformers.any((transformer) => transformer is T))
        .toIList()
        .sort((a, b) {
          final al = a.transformers.length;
          final bl = b.transformers.length;
          if (al != bl) return al - bl;

          final ai = a.transformers.indexWhere(
            (transformer) => transformer is T,
          );
          final bi = b.transformers.indexWhere(
            (transformer) => transformer is T,
          );
          if (ai != bi) return ai - bi;

          return 0;
        });
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 2 * Const.defaultPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('${widget.name}:'),
        Wrap(
          spacing: Const.defaultPadding,
          runSpacing: Const.defaultPadding,
          children: _buildWidgets(context),
        ),
      ],
    ),
  );

  List<Widget> _buildWidgets(BuildContext context) {
    final theme = Theme.of(context);
    final scope = MotionsDialog.access.of(context);
    final params = MotionsDialog.access.paramsOf(context, listen: false);
    final selectedMotion = MotionsDialog.access.select(
      context,
      (state) => state.selectedMotion,
    );
    final parent = params.parent;
    final alreadyOnList = scope.alreadyOnList;
    final widgets = <Widget>[];

    for (final template in _filteredTemplates) {
      Widget box = SizedBox.square(
        dimension: _boxSize,
        child: Motion(
          motion: template,
          animation: params.animation,
          borderRadius: _boxSize * Const.borderRadiusFactor,
          curve: parent.curve,
          flipped: parent.flipped,
          boxColor: parent.boxColor,
          alternateColor: parent.alternateColor,
          textOnBoxColor: parent.textOnBoxColor,
          textOutBoxColor: parent.textOutBoxColor,
          onTap: params.selectedMotion == null
              ? null
              : () => scope.select(template),
        ),
      );

      final selected = selectedMotion == template;

      if (selected && !alreadyOnList.contains(template)) {
        box = Hero(
          tag: params.selectedHeroTag!,
          createRectTween: (begin, end) => RectTween(begin: begin, end: end),
          child: box,
        );
        alreadyOnList.add(template);
      }

      box = Padding(
        padding: const EdgeInsets.all(_selectionPadding),
        child: box,
      );

      if (selected) {
        box = DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.colorScheme.secondary,
              width: _selectionWidth,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(
                _boxSize * Const.borderRadiusFactor + _selectionPadding,
              ),
            ),
          ),
          child: box,
        );
      }

      widgets.add(box);
    }

    return widgets;
  }
}
