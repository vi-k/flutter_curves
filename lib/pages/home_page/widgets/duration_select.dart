import 'package:auto_scroll_band/auto_scroll_band.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class DurationSelect extends StatelessWidget {
  final Widget? label;
  final List<Duration> durations;
  final Duration value;
  final void Function(Duration value)? onChanged;

  DurationSelect({
    super.key,
    this.label,
    required this.value,
    required Iterable<Duration> durations,
    this.onChanged,
  }) : durations = List.unmodifiable(durations);

  static String _toString(Duration duration) {
    final s = duration.inSeconds;
    final ms = duration.inMilliseconds % 1000;

    return s == 0 ? '$ms ms' : '$s s${ms == 0 ? '' : ' $ms ms'}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(
              left: Const.defaultPadding,
              right: Const.defaultPadding,
              bottom: Const.defaultPadding,
            ),
            child: label!,
          ),
        AutoScrollBand(
          padding: const EdgeInsets.symmetric(
            horizontal: Const.defaultPadding,
          ),
          startExtraIndent: Const.defaultPadding * 3,
          endExtraIndent: Const.defaultPadding * 3,
          selected: (index) => durations[index] == value,
          spacing: Const.defaultPadding,
          children: [
            for (final duration in durations)
              RawChip(
                backgroundColor: theme.colorScheme.primaryContainer,
                selectedColor: theme.colorScheme.primary,
                checkmarkColor: theme.colorScheme.onPrimary,
                labelStyle: TextStyle(
                  color: duration == value
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onPrimaryContainer,
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                label: Text(_toString(duration)),
                selected: duration == value,
                onSelected: (value) {
                  onChanged?.call(duration);
                },
              ),
          ],
        ),
      ],
    );
  }
  // @override
  // Widget build(BuildContext context) => Wrap(
  //       spacing: Const.defaultPadding,
  //       runSpacing: Const.defaultPadding,
  //       alignment: WrapAlignment.start,
  //       crossAxisAlignment: WrapCrossAlignment.center,
  //       children: [
  //         if (label != null) label!,
  //         for (final duration in durations)
  //           ChoiceChip(
  //             materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  //             label: Text(_toString(duration)),
  //             selected: duration == value,
  //             onSelected: (value) {
  //               onChanged?.call(duration);
  //             },
  //           ),
  //       ],
  //     );

  // SegmentedButton<Duration>(
  //       segments: [
  //         for (final duration in durations)
  //           ButtonSegment(
  //             value: duration,
  //             label: Text(_toString(duration)),
  //           ),
  //       ],
  //       selected: {value},
  //       onSelectionChanged: (values) => onChanged?.call(values.first),
  //     );
}
