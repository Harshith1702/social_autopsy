# Social Autopsy

Log conversations that went badly. Categorize what happened. Come back a few
days later and re-rate how bad it actually felt. See the pattern over time.

## Setup

This is just the `lib/` folder and `pubspec.yaml`, not a full Flutter project
scaffold (no `android/`, `ios/`, etc). To run it:

```
flutter create . --project-name social_autopsy
```

in this folder, that generates the missing platform folders without touching
your existing `lib/`, `pubspec.yaml`, or `README.md`. Then:

```
flutter pub get
flutter run
```

## Structure

```
lib/
  main.dart
  constants.dart
  db/
    db_helper.dart      sqlite setup and raw queries
    case_queries.dart   pattern report logic (breakdown, decay, repeat offenders)
  widgets/
    severity_selector.dart
    case_card.dart
  screens/
    home_screen.dart
    new_case_screen.dart
    case_detail_screen.dart
    patterns_screen.dart
```

## What's not done yet

- Evidence photo attach (image_picker is in pubspec, not wired into the UI yet)
- Delete case from the detail screen (DBHelper.deleteCase exists, no button calls it)
- Theming, currently plain ThemeData.dark(), no custom palette applied
- PDF case export
