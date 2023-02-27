import 'package:flutter/material.dart';
import 'package:flutter_scope/flutter_scope.dart';

import '../../animations/export.dart';
import '../../constants.dart';
import '../home_page/home_page_controller.dart';
import 'animations_page_controller.dart';

const double _boxSize = 60;
const double _selectionPadding = 3;
const double _selectionWidth = 2;

class AnimationsPage extends ScopeRoot<AnimationsPageController>
    with ScopeSingleTickerProviderMixin {
  final HomePageController parent;
  final Animation<double>? animation;
  final AnimationSettings? selected;
  final String? selectedHeroTag;

  const AnimationsPage({
    super.key,
    required this.parent,
    this.animation,
    this.selected,
    this.selectedHeroTag,
  }) : assert(
          selected == null && selectedHeroTag == null ||
              selected != null && selectedHeroTag != null,
          'Both selected and selectedHeroTag must be set',
        );

  @override
  AnimationsPageController createScope() => AnimationsPageController(parent);

  @override
  Widget build(BuildContext context, AnimationsPageController scope) {
    scope.alreadyOnList.clear();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select an animation'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(Const.defaultPadding),
        children: [
          _ClassRow<TranslateTransformer>('Translate', animationsTemplates),
          const SizedBox(height: Const.defaultPadding),
          _ClassRow<ScaleTransformer>('Scale', animationsTemplates),
          const SizedBox(height: Const.defaultPadding),
          _ClassRow<RotateTransformer>('Rotate', animationsTemplates),
          const SizedBox(height: Const.defaultPadding),
          _ClassRow<SkewTransformer>('Skew', animationsTemplates),
          const SizedBox(height: Const.defaultPadding),
          _ClassRow<ColorTransformer>('Color', animationsTemplates),
          const SizedBox(height: Const.defaultPadding),
          _ClassRow<BoxRadiusTransformer>('BorderRadius', animationsTemplates),
          const SizedBox(height: Const.defaultPadding),
          _ClassRow<MatrixTransformer>('Matrix', animationsTemplates),
        ],
      ),
    );
  }
}

class _ClassRow<T extends Transformer<Object?>> extends StatefulWidget {
  final String name;
  final List<AnimationSettings> templates;

  const _ClassRow(this.name, this.templates);

  @override
  State<_ClassRow<T>> createState() => _ClassRowState<T>();
}

class _ClassRowState<T extends Transformer<Object?>>
    extends State<_ClassRow<T>> {
  late List<AnimationSettings> _filteredTemplates;

  @override
  void initState() {
    super.initState();

    _filteredTemplates = widget.templates
        .where((settings) =>
            settings.transformers.any((transformer) => transformer is T))
        .toList();
  }

  @override
  Widget build(BuildContext context) => ScopeBuilder<AnimationsPageController>(
        builder: (context, scope, _) => Column(
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
      );

  List<Widget> _buildWidgets(AnimationsPageController scope) {
    final theme = Theme.of(context);
    final alreadyOnList = scope.alreadyOnList;
    final widgets = <Widget>[];

    for (final template in _filteredTemplates) {
      Widget box = SizedBox.square(
        dimension: _boxSize,
        child: AnimationBox(
          settings: template,
          animation: scope.animation,
          borderRadius: _boxSize * Const.borderRadiusFactor,
          curve: scope.parent.curve,
          flipped: scope.parent.flipped,
          boxColor: scope.parent.boxColor,
          alternateColor: scope.parent.alternateColor,
          textOnBoxColor: scope.parent.textOnBoxColor,
          textOutBoxColor: scope.parent.textOutBoxColor,
          onTap: scope.widget.selected == null
              ? null
              : () => scope.select(template),
        ),
      );

      final selected = scope.selected == template;

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
