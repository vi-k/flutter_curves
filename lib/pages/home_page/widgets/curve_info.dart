import 'package:flutter/material.dart';

import '../../../curves/export.dart';
import '../home_scope.dart';

class CurveInfo extends StatelessWidget {
  const CurveInfo({super.key});

  @override
  Widget build(BuildContext context) => Text(
    describeCurve(HomeScope.access.select(context, (state) => state.curve)),
    textAlign: TextAlign.center,
  );
}
