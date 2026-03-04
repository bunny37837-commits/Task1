# DECISIONS.md — Technical Decisions Log

## [DEC-001] Architecture Pattern
Date: 2026-03-03
Status: Superseded

Decision: Single-module Android app with Activity-based UI + repository abstraction over Room.
Reason: Initial MVP attempt prioritized native Android implementation speed.
Rejected: Flutter-first implementation in the first pass.
Impact: Superseded by DEC-007 to align with pure Flutter requirement.

## [DEC-002] Database / Storage
Date: 2026-03-03
Status: Superseded

Decision: Room database (`TaskEntity`, `TaskDao`) for persistent task storage.
Reason: Reliable structured offline persistence in native Android.
Rejected: Flutter-local persistence in initial pass.
Impact: Native data layer removed in pure Flutter repair.

## [DEC-003] Key Libraries / Dependencies
Date: 2026-03-04
Status: Decided

Decision: Flutter-first stack with `flutter_overlay_window`, `flutter_local_notifications`, `workmanager`, `permission_handler`, and `flutter_riverpod`.
Reason: Required by PR repair guidance and pure Flutter acceptance criteria.
Rejected: Native Android-only libraries as primary implementation path.
Impact: Repository now follows Flutter app layout and Flutter CI workflow.

## [DEC-004] Network Access
Date: 2026-03-03
Status: Not Required

Decision: Network OFF for runtime app behavior.
Allowed Domains: None at runtime.
Reason: SPEC requires 100% offline behavior with no backend/cloud usage.

## [DEC-005] Security Approach
Date: 2026-03-03
Status: Decided

Decision: No credential handling; local-only app behavior.
Reason: App scope excludes authentication and remote APIs.
Impact: Reduced attack surface and simpler compliance with offline requirement.

## [DEC-006] Flutter dependency and CI alignment repair
Date: 2026-03-04
Status: Decided

Decision: Keep valid package versions and avoid codegen/build_runner unless used.
Reason: Mergeability and toolchain stability requirements.
Rejected: Introducing generator chains without actual codegen usage.
Impact: Cleaner dependency graph and CI alignment.

## [DEC-007] Pure Flutter project structure
Date: 2026-03-04
Status: Decided

Decision: Remove standalone native `:app` Android implementation and use standard Flutter project layout (`lib/`, `android/` scaffold, Flutter CI APK build).
Reason: Explicit instruction to stop adding non-Flutter native app code.
Rejected: Keeping root-native Gradle project with custom Android module.
Impact: PR is aligned with expected Flutter architecture and CI can build APK via Flutter.


## [DEC-008] Binary-free repository policy for PR compatibility
Date: 2026-03-04
Status: Decided

Decision: Keep repository source-only and exclude binary/build artifacts (`*.jar`, `*.apk`, `*.aab`, `build/`, `.dart_tool/`).
Reason: Prior PR creation failed due to binary-file handling limitation.
Rejected: Committing generated binaries to source control.
Impact: Improves mergeability and prevents PR tooling failures.


## [DEC-009] Conflict-resolution baseline files
Date: 2026-03-04
Status: Decided

Decision: Normalize roadmap/docs/manifest to Flutter-first wording and valid Android icon reference in this repair pass.
Reason: Requested conflict resolution targeted these exact files and required a mergeable, coherent baseline.
Rejected: Keeping mixed native-Android wording from superseded implementation.
Impact: Reduced drift between code, docs, and CI expectations.
