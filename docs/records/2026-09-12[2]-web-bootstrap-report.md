# Починка веб-загрузчика

> **Состояние на 2026-09-12:** сделано и смержено в `main`, коммит
> проставлен ниже после мержа.
> **Что это:** разбор двух предупреждений `flutter build web`; первое
> оказалось не предупреждением, а сломанной release-сборкой.
> **Связанные записи:** `2026-09-12[1]-scopo-migration-report.md` — там
> release-сборка была объявлена рабочей по факту успешной компиляции.

## Повод

После миграции `flutter build web` собирался, но ругался трижды:

```
Warning: In index.html:37: Flutter's service worker is deprecated…
Warning: In index.html:46: "FlutterLoader.loadEntrypoint" is deprecated…
Expected to find fonts for (MaterialIcons,
packages/cupertino_icons/CupertinoIcons), but found (MaterialIcons).
```

Владелец попросил убрать первое и второе.

## Первое оказалось дефектом, а не косметикой

`web/index.html` был от `flutter create` 2023 года: он объявлял
`serviceWorkerVersion` и поднимал приложение через
`_flutter.loader.loadEntrypoint`. Flutter с тех пор сменил загрузчик на
`flutter_bootstrap.js`, а старый путь оставил с предупреждением.

**Предупреждение врало о степени беды.** Release-сборка на этом загрузчике
не поднималась вовсе: вкладка получала заголовок из `MaterialApp`, то есть
Dart-код доходил до построения приложения, а на экране оставалась белизна.
Отладочная сборка при этом работала — поэтому в
`2026-09-12[1]-scopo-migration-report.md` release и записан как
проверенный: там проверка кончилась на «✓ Built build/web», а страницу
открывали отладочную.

`web/index.html` заменён на текущий шаблон SDK
(`packages/flutter_tools/templates/app/web/index.html.tmpl`): весь блок
инициализации — одна строка `<script src="flutter_bootstrap.js" async>`.
Заодно ушёл третий устаревший ярлык, `apple-mobile-web-app-capable` →
`mobile-web-app-capable`.

Вместе с этим поправлены описания, оставшиеся от шаблона: `A new Flutter
project.` в `web/index.html` и `web/manifest.json` заменено на описание из
`pubspec.yaml`.

**Урок для проверок:** «собралось» и «работает» для web — разные
утверждения, и отладочная сборка за release не отвечает. Если правка
трогает подъём приложения, release надо открыть, а не собрать.

## Второе — `Slider.adaptive`

Шрифтов `CupertinoIcons` в сборке не хватало не по ошибке в коде.
`Slider.adaptive` — единственный адаптивный виджет в проекте
(`lib/pages/home_page/home_page.dart`) — тянет за собой
`package:flutter/cupertino.dart` целиком, а там `text_field.dart`,
`nav_bar.dart`, `list_tile.dart` и другие ссылаются на константы
`CupertinoIcons`. Сборщик их видит, а пакета со шрифтом в зависимостях
нет — отсюда и жалоба.

Выходов было два: отказаться от `Slider.adaptive` (на Apple-платформах
слайдер сменил бы вид — правка поведения, а не предупреждения) или
объявить `cupertino_icons`, как и делает `flutter create` по умолчанию.
Взят второй: поведение не меняется, а цена нулевая — шрифт ужимается
деревом до 1472 байт из 257628.

## Проверено

```sh
flutter analyze                              # No issues found!
flutter test                                 # 4 теста, все зелёные
dart format --set-exit-if-changed lib test   # 0 changed
flutter build web --base-href /              # ✓ Built, без предупреждений
```

Release-сборка поднята в браузере: экран рисуется, моушены идут, контролы
на месте. Осталась одна строка вывода — подсказка про `--wasm`, она
информационная.
