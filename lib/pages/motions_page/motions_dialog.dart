import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scope/flutter_scope.dart';

import '../../constants.dart';
import '../../motions/export.dart';
import '../home_page/home_page_controller.dart';
import 'motions_dialog_controller.dart';

const double _boxSize = 60;
const double _selectionPadding = 3;
const double _selectionWidth = 2;

class MotionsDialog extends ScopeRoot<MotionsDIalogController>
    with ScopeSingleTickerProviderMixin {
  const MotionsDialog({
    super.key,
    required this.parent,
    this.animation,
    this.selectedMotion,
    this.selectedHeroTag,
  }) : assert(
          selectedMotion == null && selectedHeroTag == null ||
              selectedMotion != null && selectedHeroTag != null,
          'Both selected and selectedHeroTag must be set',
        );

  final HomePageController parent;
  final Animation<double>? animation;
  final MotionObject? selectedMotion;
  final String? selectedHeroTag;

  @override
  MotionsDIalogController createScope() => MotionsDIalogController(parent);

  @override
  Widget build(BuildContext context, MotionsDIalogController scope) {
    scope.alreadyOnList.clear();

    return Column(
      children: [
        AppBar(
          title: const Text('Select a motion'),
        ),
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
        .where(
          (e) => e.transformers.any((transformer) => transformer is T),
        )
        .toIList()
        .sort(
      (a, b) {
        final al = a.transformers.length;
        final bl = b.transformers.length;
        if (al != bl) return al - bl;

        final ai = a.transformers.indexWhere((transformer) => transformer is T);
        final bi = b.transformers.indexWhere((transformer) => transformer is T);
        if (ai != bi) return ai - bi;

        return 0;
      },
    );
  }

  @override
  Widget build(BuildContext context) => ScopeBuilder<MotionsDIalogController>(
        builder: (context, scope, _) => Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 2 * Const.defaultPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('${widget.name}:'),
              Wrap(
                spacing: Const.defaultPadding,
                runSpacing: Const.defaultPadding,
                children: _buildWidgets(scope),
              ),
            ],
          ),
        ),
      );

  List<Widget> _buildWidgets(MotionsDIalogController scope) {
    final theme = Theme.of(context);
    final alreadyOnList = scope.alreadyOnList;
    final widgets = <Widget>[];

    for (final template in _filteredTemplates) {
      Widget box = SizedBox.square(
        dimension: _boxSize,
        child: Motion(
          motion: template,
          animation: scope.animation,
          borderRadius: _boxSize * Const.borderRadiusFactor,
          curve: scope.parent.curve,
          flipped: scope.parent.flipped,
          boxColor: scope.parent.boxColor,
          alternateColor: scope.parent.alternateColor,
          textOnBoxColor: scope.parent.textOnBoxColor,
          textOutBoxColor: scope.parent.textOutBoxColor,
          onTap: scope.widget.selectedMotion == null
              ? null
              : () => scope.select(template),
        ),
      );

      final selected = scope.selectedMotion == template;

      if (selected && !alreadyOnList.contains(template)) {
        box = Hero(
          tag: scope.widget.selectedHeroTag!,
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
