# Project Skill — TaskRemind Pro

## Build Commands

1. `flutter pub get`

2. `flutter pub run build_runner build --delete-conflicting-outputs`

3. `flutter build apk --release --no-tree-shake-icons`

## Repo Workflow

1. Read SPEC.md before implementing.

2. Implement one milestone at a time.

3. Update STATUS.md after each milestone.

4. Commit with milestone-prefixed messages.

## Verification Steps

- flutter pub get passes

- build_runner succeeds

- APK builds successfully

## Project Conventions

- Flutter + Riverpod + Isar

- Android-only, offline-first

- No internet permission

- No business logic in widgets