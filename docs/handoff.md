# Состояние проекта

> Актуально на 2026-09-11. Здесь только текущее состояние: на чём
> остановились, что сломано, что проверено. История правок — в
> `docs/records/`, пожелания владельца — в `docs/backlog.md`, устройство
> приложения — в `docs/architecture.md`.

## Коротко

`flutter_curves` — демонстрационное Flutter-приложение про кривые анимации
(`Curve`): слева и справа от графика кривой идут ряды «моушенов», которые
проигрываются по выбранной кривой. Версия `0.4.0`, на pub.dev не
публикуется.

**Главное: приложение сейчас не собирается.** Код не трогали с 2023-03-12,
а локальный тулчейн ушёл вперёд на три года. Пока это не решено, ни одна
проверка из гейта §6 `AGENTS.md` не запускается.

## Где остановились

Последний коммит — `b353be7 add motions` от 2023-03-12, всего в истории семь
коммитов. Работа над кодом не идёт: открытая задача — вернуть проект в
рабочее состояние, см. «Что мешает» ниже.

В этой сессии заведена документация для восстановления контекста после
обрыва сессии: `AGENTS.md`, `CLAUDE.md`, `docs/handoff.md`,
`docs/backlog.md`, `docs/architecture.md`, `docs/conventions.md`,
`docs/records/`, русский перевод `README.ru.md`. Смержено в `main`
коммитом `255c898`, код при этом не менялся. Подробности —
`docs/records/2026-09-11[1]-docs-bootstrap-report.md`.

## Что мешает — три расхождения с тулчейном

1. **Нет пакета `flutter_scope`.** `pubspec.yaml` требует его по пути
   `../flutter_scope`, каталога не существует. Похоже, пакет переродился в
   соседний `../scopo` (версия `0.14.0`), но API у него уже другой:
   `ScopeRoot`, `ScopeWidget`, `ScopeBuilder`, `ScopeChildController`,
   `ScopeControllerSingleTickerProviderMixin` там в прежнем виде не
   встречаются, есть `Scope`, `ScopeController`, `ScopeModel`,
   `ScopeNotifier`, `LiteScope`, `ScopeWidgetBase`. Миграция — не замена
   строки в `pubspec.yaml`, а переписывание пяти файлов в `lib/` (список —
   в разделе «Кто зависит от `flutter_scope`»).
2. **Пол SDK от 2023 года.** В `pubspec.yaml` стоит
   `sdk: ">=2.19.0 <3.0.0"`, локально — Flutter 3.47.0 с Dart 3.13.0.
   `fvm` в проекте не заведён, старого SDK под рукой нет. Коммит
   `45848b7 remove Dart 3.0 :(` показывает, что пол опускали намеренно, но
   причина в истории не записана.
3. **`pubspec.lock` рассогласован с `pubspec.yaml`.** В рабочем дереве лок
   уже без `flutter_scope` и с пакетами эпохи Dart 3 (`collection 1.19.1`,
   `leak_tracker`), а `pubspec.yaml` всё ещё требует `flutter_scope`. Это
   **чужая незакоммиченная правка** (см. «Рабочее дерево»), трогать её
   нельзя.

## Рабочее дерево — чужие правки

В дереве лежат незакоммиченные изменения владельца. **Они не мои, коммитить
их вместе со своими нельзя:**

- `analysis_options.yaml` — секция `exclude` переписана со словаря на
  список, из исключений убраны `lib/**.g.dart`, `lib/**.freezed.dart`,
  `assets/**` и добавлены платформенные каталоги;
- `pubspec.yaml` — одинарные кавычки заменены на двойные (косметика);
- `pubspec.lock` — перерешён без `flutter_scope`, пакеты подняты до версий
  эпохи Dart 3.

## Что проверено и чем

Прогоны 2026-09-11 на локальном Flutter 3.47.0 / Dart 3.13.0:

- `dart pub get --dry-run` — **падает**:
  `Because flutter_curves depends on flutter_scope from path which doesn't
  exist (could not find package flutter_scope at "../flutter_scope"),
  version solving failed.`
- `dart analyze lib test` — **127 замечаний: 78 ошибок, 19 предупреждений,
  30 info**. Все ошибки вторичны: `uri_does_not_exist` на
  `package:flutter_scope/flutter_scope.dart` и всё, что из этого следует
  (`extends_non_class`, `mixin_of_non_class`, `undefined_identifier` на
  `Scope`). Отдельных дефектов среди них нет.
- `flutter analyze` и `flutter test` **не запускались**: они сначала делают
  `pub get`, который падает.

Уровень info — устаревшие API, накопившиеся за три года: `onBackground` →
`onSurface`, `withOpacity` → `withValues`, `Matrix4.translate`/`scale` →
`translateByVector3`/`scaleByDouble`. Их чинить имеет смысл только после
того, как проект снова начнёт разрешаться.

## Тестов нет

`test/widget_test.dart` — нетронутый шаблон `flutter create` про счётчик:
ищет текст `'0'` и иконку `Icons.add`, которых в этом приложении нет. Он не
относится к проекту и упадёт, как только сборка оживёт. Первый настоящий
тест заводится с нуля.

## Кто зависит от `flutter_scope`

Пять файлов, всё — слой страниц:

- `lib/app.dart` — `Scope`, `Scope.watch<AppState>`;
- `lib/pages/home_page/home_page.dart` — `ScopeRoot`,
  `ScopeSingleTickerProviderMixin`, `ScopeWidget` (девять приватных
  виджетов);
- `lib/pages/home_page/home_page_controller.dart` — `ScopeController`,
  `ScopeControllerSingleTickerProviderMixin`;
- `lib/pages/motions_page/motions_dialog.dart` — `ScopeRoot`,
  `ScopeBuilder`;
- `lib/pages/motions_page/motions_dialog_controller.dart` —
  `ScopeChildController`, `ScopeWidgetProviderMixin`.

Слои `lib/motions/`, `lib/curves/` и `lib/common/` от `flutter_scope` не
зависят вовсе — при миграции их трогать не придётся.

## Известные дефекты в коде

Найдены чтением кода 2026-09-11, ни один **не проверен прогоном** — проект
не собирается. Ни один не исправлен.

- `lib/motions/motion/transformers/motion_transformer.dart:48` —
  `HasAlignment.finalize` вызывает `super.prepare(state)` вместо
  `super.finalize(state)`. Похоже на опечатку копипастой; для одиночного
  миксина последствий нет, но цепочка `finalize` по миксинам разорвана.
- `lib/motions/motion/objects/motion_object.dart:23` и `:46` —
  `MotionObject.prepare` и `MotionObject.finalized` не вызываются нигде.
  `Motion` зовёт сразу `paint`. Похоже на незаконченный рефакторинг:
  `save`/`restore` канвы сейчас делает сам `paint`.
- Мёртвый код: `SimpleCurveBox`
  (`lib/curves/widgets/simple_surve_box.dart`) не используется и не
  экспортируется из `lib/curves/export.dart`, а в
  `lib/pages/home_page/home_page.dart:282` живёт его приватный дубль
  `_SimpleCurve`; enum `RectAlignment`
  (`lib/motions/motion/objects/rect_ext.dart:5`) не используется;
  конструктор `DraftColor.byColorType`
  (`lib/motions/motion/color_type.dart:23`) не используется.
- `lib/motions/motion/objects/motion_object.dart:21` — поле `clip` не
  обрезает ничего: в `lib/motions/widgets/motion.dart:77` по нему
  выбирается, оборачивать ли бокс в `InkWell`. Значение по умолчанию
  `true`, ни один шаблон его не переопределяет, так что ветка
  `!motion.clip` недостижима.
- Опечатки в именах, разъехавшиеся по коду: файл `simple_surve_box.dart`
  («surve»), класс `MotionsDIalogController` («DIalog»), поля
  `curveHorisontalMultiplier` / `horisontalMultiplier` («Horisontal»).
- `lib/motions/motion_controller/motion_controller.dart:61` — `start()`
  крутит бесконечный цикл `while (state.mounted)` с `await`; владение
  циклом держится на `mounted` чужого `State`, переданного как
  `TickerProvider`. Конструктор это и подпирает ассертом
  `vsync is State`. Работает, но связь хрупкая.

## Ближайший шаг

Решение по пункту 1 «Что мешает» — за владельцем: мигрировать на `scopo`
или восстановить `flutter_scope`. Всё остальное (пол SDK, устаревшие API,
тесты, мёртвый код) упирается в него и до него не двигается.
