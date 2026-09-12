import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../home_scope.dart';

class FlippedSwitch extends StatelessWidget {
  const FlippedSwitch({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(
      top: Const.defaultPadding,
      left: Const.defaultPadding,
      right: Const.defaultPadding,
    ),
    child: Row(
      children: [
        const Expanded(
          child: Text(
            'Flip it over when it goes back:',
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Switch(
          value: HomeScope.access.select(context, (state) => state.flipped),
          onChanged: (value) => HomeScope.access.of(context).flipped = value,
        ),
      ],
    ),
  );
}
