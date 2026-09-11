# flutter_curves

An interactive playground for Flutter's animation curves.

The screen shows the graph of a `Curve` — grid, axes, control points and a
dot running along it — with two rows of small animated tiles on either
side. Every tile replays the same curve over the same duration in a
different way: translate, scale, rotate, skew, fade, color, border radius
or a raw matrix. Seeing the graph and a dozen animations driven by one
controller side by side is the whole point.

## What you can do

- Pick a curve from the full `Curves` catalogue, plus a few hand-built
  `ThreePointCubic` variants.
- Shape a `Cubic` with four sliders, or an `ElasticIn/Out/InOut` with its
  type and period. The graph, the sliders and the tiles stay in sync
  whichever one you move.
- Set the animation duration and the pause between runs.
- Flip the curve on the way back, to compare `curve.flipped` against the
  plain curve.
- Tap any tile to swap the motion in it for another one.
- Switch between light and dark themes.

## Running

```sh
flutter pub get
flutter run
```

## Requirements

Two dependencies are local path packages resolved from sibling
directories, so a standalone clone will not resolve until they are in
place next to this repository:

- `../flutter_scope` — scopes and controllers;
- `../auto_scroll_band` — the chip strip that scrolls to the selected item.

The SDK floor in `pubspec.yaml` is Dart 2.19, which means a Flutter 3.7-era
toolchain.

## License

BSD 2-Clause. See `LICENSE`.
