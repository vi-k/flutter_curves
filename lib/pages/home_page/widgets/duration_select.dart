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
  Widget build(BuildContext context) => Wrap(
        spacing: Const.defaultPadding,
        runSpacing: Const.defaultPadding,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (label != null) label!,
          for (final duration in durations)
            ChoiceChip(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(100)),
              ),
              label: Text(_toString(duration)),
              selected: duration == value,
              onSelected: (value) {
                onChanged?.call(duration);
              },
            ),
        ],
      );

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
