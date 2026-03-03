# TaskRemind Pro

Offline Android reminder app built with Flutter.

## Implemented in V1
- Android-only scaffold (`com.taskremind.pro`)
- Task list + creation bottom sheet
- One-time / daily reminder scheduling service
- Overlay reminder UI with Done / Snooze / Dismiss and 12-second timeout
- Settings for reminder toggle, overlay permission, battery optimization, theme mode, app version
- CI workflow to build release APK artifact

## Commands
```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter test
flutter build apk --release --no-tree-shake-icons
```

## Assumptions Log
ASSUMPTION: Flutter SDK is unavailable in this container, so runnable verification is delegated to CI/local Flutter environments.
Reason: `flutter --version` returns command-not-found.
Impact: Build/test proofs cannot be executed in this session.
Reversible: yes

ASSUMPTION: Repository abstraction can start in-memory and be swapped to Isar persistence in V2 after codegen is available.
Reason: Isar schema generation requires Flutter tooling that is unavailable in this session.
Impact: Current runtime persistence is non-durable.
Reversible: yes
