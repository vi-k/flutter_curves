import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../curves/export.dart';
import '../home_scope.dart';

class CubicControls extends StatelessWidget {
  const CubicControls({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = HomeScope.access.of(context);
    final enabled = HomeScope.access.select(
      context,
      (state) => state.curve is Cubic,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _CurveSlider(
          label: 'Cubic x1:',
          enabled: enabled,
          value: HomeScope.access.select(context, (state) => state.cubicA),
          onChanged: (value) => scope.cubicA = value,
        ),
        _CurveSlider(
          label: 'Cubic y1:',
          enabled: enabled,
          value: HomeScope.access.select(context, (state) => state.cubicB),
          onChanged: (value) => scope.cubicB = value,
        ),
        _CurveSlider(
          label: 'Cubic x2:',
          enabled: enabled,
          value: HomeScope.access.select(context, (state) => state.cubicC),
          onChanged: (value) => scope.cubicC = value,
        ),
        _CurveSlider(
          label: 'Cubic y2:',
          enabled: enabled,
          value: HomeScope.access.select(context, (state) => state.cubicD),
          onChanged: (value) => scope.cubicD = value,
        ),
      ],
    );
  }
}

class ElasticControls extends StatelessWidget {
  const ElasticControls({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = HomeScope.access.of(context);
    final enabled = HomeScope.access.select(
      context,
      (state) => isElasticCurve(state.curve),
    );

    return Row(
      children: [
        Expanded(
          child: _Slider(
            label: 'Elastic:',
            enabled: enabled,
            min: 0,
            max: 2,
            divisions: 3,
            value: HomeScope.access
                .select(context, (state) => state.elasticType)
                .toDouble(),
            onChanged: (value) => scope.elasticType = value.round(),
            valueBuilder: (value) => SizedBox(
              width: 30,
              child: Text(switch (value.round()) {
                0 => 'in',
                1 => 'out',
                2 => 'in out',
                _ => '',
              }, textAlign: TextAlign.center),
            ),
          ),
        ),
        Expanded(
          child: _CurveSlider(
            enabled: enabled,
            min: 0.1,
            max: 2,
            value: HomeScope.access.select(
              context,
              (state) => state.elasticPeriod,
            ),
            onChanged: (value) => scope.elasticPeriod = value,
          ),
        ),
      ],
    );
  }
}

class _Slider extends StatelessWidget {
  const _Slider({
    this.label,
    required this.enabled,
    required this.value,
    required this.min,
    required this.max,
    this.divisions,
    required this.onChanged,
    this.valueBuilder,
  });

  final String? label;
  final bool enabled;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final void Function(double value) onChanged;
  final Widget Function(double value)? valueBuilder;

  @override
  Widget build(BuildContext context) => Opacity(
    opacity: enabled ? 1 : 0.5,
    child: Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: Const.defaultPadding,
      ),
      child: Row(
        children: [
          if (label != null) Text(label!),
          Expanded(
            child: Slider.adaptive(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
          if (valueBuilder != null) valueBuilder!(value),
        ],
      ),
    ),
  );
}

class _CurveSlider extends _Slider {
  _CurveSlider({
    super.label,
    required super.value,
    super.min = -0.6,
    super.max = 1.6,
    required super.onChanged,
    required super.enabled,
  }) : super(
         divisions: ((max - min) * 100).round(),
         valueBuilder: (value) => SizedBox(
           width: 40,
           child: Text(value.toStringAsFixed(2), textAlign: TextAlign.end),
         ),
       );
}
