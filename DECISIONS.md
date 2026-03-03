# DECISIONS.md — Technical Decisions Log

## [DEC-001] Architecture Pattern
Date: 2026-03-03
Status: Decided

Decision: Flutter + Riverpod state management with feature-first folders and service layer separation.
Reason: Keeps UI declarative while isolating scheduling/overlay behavior from widgets.
Rejected: Heavy MVVM boilerplate and BLoC; both add complexity for V1 scope.
Impact: Controllers own state transitions, widgets remain presentation focused.

## [DEC-002] Database / Storage
Date: 2026-03-03
Status: Decided

Decision: Target Isar as the long-term local database model.
Reason: SPEC requires Isar and offline storage.
Rejected: SQLite and shared_preferences because they diverge from SPEC package mandate.
Impact: Task model structured for Isar annotations; V1 repo abstraction prepared for Isar-backed swap.

## [DEC-003] Key Libraries / Dependencies
Date: 2026-03-03
Status: Decided

Decision: Use the dependency set pinned in SPEC.md (Riverpod, Isar, local notifications, overlay window, workmanager, permission handler, package info).
Reason: Aligns with requirements and Android reminder feature set.
Impact: pubspec and service scaffolding match required package ecosystem.

## [DEC-004] Network Access
Date: 2026-03-03
Status: Not Required

Decision: Network OFF.
Allowed Domains: None.
Reason: App is explicitly offline-only with no backend/cloud sync.

## [DEC-005] Security Approach
Date: 2026-03-03
Status: Decided

Decision: Minimize permission surface to local reminder needs and explicitly avoid INTERNET permission.
Reason: Reduces attack surface and enforces offline requirement.
Impact: AndroidManifest requests only notification/alarm/overlay/battery related permissions.

## [DEC-006] Build Verification in Restricted Environment
Date: 2026-03-03
Status: Decided

Decision: Use static file validation and document non-executable Flutter commands when Flutter SDK is missing.
Reason: The execution environment does not include `flutter`; runtime build cannot execute here.
Rejected: Mocking build success without proof.
Impact: STATUS and final report explicitly mark verification limitation.
