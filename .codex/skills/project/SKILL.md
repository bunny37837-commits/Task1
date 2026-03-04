# Project Skill — TaskRemind Pro

## Build commands
- `flutter pub get`
- `flutter analyze`
- `flutter test`
- `flutter build apk --release`

## Repo workflow
1. Read `SPEC.md`, `PLANS.md`, and `DECISIONS.md` before implementing.
2. Keep implementation pure Flutter unless SPEC explicitly requires native modules.
3. Keep docs (`PLANS.md`, `DECISIONS.md`, `STATUS.md`) synchronized.
4. Commit small, milestone-prefixed logical changes.

## Verification steps
1. Resolve dependencies with `flutter pub get`.
2. Run static checks with `flutter analyze`.
3. Run tests with `flutter test`.
4. Build Android artifact with `flutter build apk --release`.

## Project conventions
- Offline-only architecture.
- Use valid published package versions.
- Avoid codegen/build_runner unless actively used.
