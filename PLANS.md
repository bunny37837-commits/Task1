# PLANS.md — Project Roadmap

## Status
[x] In Progress — Current: V1

## V1 — Core Working Feature

### Goal
Deliver a pure Flutter Android reminder app with local task management, daily reminder workflow, and overlay-ready dependency setup.

### Acceptance Criteria
- [x] Flutter project structure is standard (`lib/`, `android/`, `pubspec.yaml`).
- [x] Core task UI supports add/delete and time selection.
- [x] Global reminder and dark mode toggles exist in UI state.
- [x] CI runs Flutter dependency + analyze + APK build steps.
- [ ] Reminder delivery + overlay actions are fully implemented end-to-end in Flutter runtime.

### Tasks
- [x] Remove non-Flutter native module implementation.
- [x] Add Flutter app scaffold and Riverpod state.
- [x] Configure Flutter Android host project and CI.
- [ ] Implement full reminder scheduling + overlay interactions.

### Estimated Scope
Single Flutter app targeting Android, offline-only behavior.

## V2 — Complete Feature Set

### Goal
Complete full reminder behavior and improve UX reliability.

### Acceptance Criteria
- [ ] Reminder fires at configured daily time.
- [ ] Overlay popup supports Done / Snooze 10m / Dismiss actions.
- [ ] Task editing flow and persistence survive app restarts.

### Tasks
- [ ] Add local persistence and restore on startup.
- [ ] Integrate reminder + notification/overlay package flows.
- [ ] Implement edit flow and permission guidance screen.

## V3 — Production Ready

### Goal
Stabilize and ship-ready hardening.

### Acceptance Criteria
- [ ] Build passes all checks.
- [ ] No known critical issues.
- [ ] Docs complete.

### Tasks
- [ ] Hardening and bug fixes.
- [ ] Final verification loop.
- [ ] STATUS.md marked complete.

## Risks & Blockers
| Risk | Impact | Mitigation |
|------|--------|------------|
| Flutter SDK absent in local execution environment | High | Validate via CI and local dev machines with Flutter installed |
| Android overlay behavior may vary by OEM | High | Add explicit permission guide + fallback notification UX |

## Milestone History
| Milestone | Completed On | Verified By |
|-----------|-------------|-------------|
| V1 architecture conversion | 2026-03-04 | Repo structure audit + CI workflow definition |
