# Project Skill — TaskRemind Pro

## Build Commands
1. `flutter pub get`
2. `flutter pub run build_runner build --delete-conflicting-outputs`
3. `flutter test`
4. `flutter build apk --release --no-tree-shake-icons`

## Repo Workflow
1. Update SPEC.md aligned docs first.
2. Implement one milestone at a time (V1 -> V2 -> V3).
3. Run verification loop before commit.
4. Commit with milestone-prefixed conventional commit messages.

## Verification Steps
- Build succeeds.
- Tests pass.
- Output is runnable.
- STATUS.md updated.

## Project Conventions
- Riverpod annotations + generated providers.
- Isar collections for persistence.
- No business logic in widgets.
- Android-only, offline-first, no internet permission.
