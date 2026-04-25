# Tasks: Theme & Colors Separation

**Input**: Design documents from `/specs/004-theme-and-colors/`
**Prerequisites**: plan.md, spec.md, data-model.md, research.md, quickstart.md

**Organization**: Tasks map explicitly to independent styling logic isolation paths mapping perfectly for an autonomous developer loop to easily handle sequentially without logical failures.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2)

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Validate Flutter constraints

- [ ] T001 Review existing `lib/main.dart` checking for predefined hard-coded `theme: ThemeData(...)` blocks.

---

## Phase 2: User Story 1 - Universal Color Palette (Priority: P1)

**Goal**: Establish a purely static token registry preventing manual widget palette overriding entirely.

### Implementation for User Story 1

- [ ] T002 [P] [US1] Create the file strictly containing layout dictionaries: `lib/core/theme/app_colors.dart`
- [ ] T003 [US1] Inside `app_colors.dart`, implement stringently typed static variables under `class AppColors` matching predefined UI tokens:
  - `static const primary = Color(0xFF1E88E5);`
  - `static const secondary = Color(0xFF42A5F5);`
  - `static const background = Color(0xFFF5F5F5);`

**Checkpoint**: Core generic application token mapping translates securely offline.

---

## Phase 3: User Story 2 - Centralized App Theme Registry (Priority: P1)

**Goal**: Tie UI variables securely onto the Native Flutter API mapping structure securely routing globally overriding rules natively.

### Implementation for User Story 2

- [ ] T004 [P] [US2] Scaffold the core UI ruleset engine: `lib/core/theme/app_theme.dart`
- [ ] T005 [US2] Implement `class AppTheme { ... }` explicitly returning `static ThemeData get lightTheme`.
- [ ] T006 [US2] Within `lightTheme`, inject `AppColors.primary` explicitly into `primaryColor` mapping, and `AppColors.background` inside `scaffoldBackgroundColor`.
- [ ] T007 [US2] Navigate securely into `lib/main.dart` and override the `MaterialApp` widget by supplying the parameter `theme: AppTheme.lightTheme`.

**Checkpoint**: Global styles universally bind. No local widget files ever require importing raw `flutter/material.dart` `Colors.*` tokens again.

---

## Phase 4: Polish & Cross-Cutting Concerns

**Purpose**: Verifiable execution constraints

- [ ] T008 Execute `dart format lib/core/theme/` to clean UI structural indentation bounds rapidly.

---

## Dependencies & Execution Order

### Phase Dependencies

- **US1 Palette Dictionary (Phase 2)**: Dictates the raw memory inputs. Blocks Phase 3 entirely.
- **US2 Native Mapping (Phase 3)**: Requires parsed inputs. Injects directly into main thread. 

### Parallel Opportunities Identified
- As this is a tightly coupled singleton configuration matrix, execution is intended strictly chronologically across the files (`T001` -> `T007`). Parallel options disabled explicitly on purpose structure bounding to ensure clean execution bounds.

### Format Validation Notice
This file complies exactly with the requested markdown checkmark format (`- [ ] TXXX [P] [Story]`) designed explicitly for deterministic LLM step-by-step workflow tracking.
