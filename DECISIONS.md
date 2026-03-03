# DECISIONS.md — Technical Decisions Log

## [DEC-001] Architecture Pattern
Date: 2026-03-03
Status: Decided

Decision: Single-module Android app with Activity-based UI + repository abstraction over Room.
Reason: Fastest path to a working offline MVP with maintainable separation between UI and storage.
Rejected: Full MVVM with ViewModels/Flows (more boilerplate for current scope).
Impact: Clear local data layer and simpler incremental evolution to MVVM later.

## [DEC-002] Database / Storage
Date: 2026-03-03
Status: Decided

Decision: Room database (`TaskEntity`, `TaskDao`) for persistent task storage.
Reason: Reliable structured offline persistence, lifecycle-safe and Kotlin-friendly.
Rejected: Raw SQLite (higher manual maintenance), file-based JSON (weaker schema safety).
Impact: Stable local task persistence across app restarts and device reboots.

## [DEC-003] Key Libraries / Dependencies
Date: 2026-03-03
Status: Decided

Decision: AndroidX AppCompat/Material/RecyclerView + Room + Coroutines.
Reason: Mature stack with minimal complexity for this feature set.
Impact: Standard Android development workflow and broad compatibility.

## [DEC-004] Network Access
Date: 2026-03-03
Status: Not Required

Decision: Network OFF.
Allowed Domains: None.
Reason: SPEC requires 100% offline behavior with no backend/cloud usage.

## [DEC-005] Security Approach
Date: 2026-03-03
Status: Decided

Decision: No credential handling; local-only storage; explicit runtime permission guidance for overlay/notifications.
Reason: App scope excludes authentication and remote APIs.
Impact: Reduced attack surface and simpler compliance with offline requirement.
