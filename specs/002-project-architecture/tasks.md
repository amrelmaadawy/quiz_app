# Tasks: Project Architecture

**Input**: Design documents from `/specs/002-project-architecture/`
**Prerequisites**: plan.md, spec.md, data-model.md, research.md, quickstart.md

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story. This specification maps the scaffolding boundary definitions necessary to lock out poor architectural choices. 

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Explicit target locations listed for a lower-capability LLM to follow blindly.

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic dependencies

- [ ] T001 Initialize packages `dartz`, `equatable`, `get_it`, and `flutter_bloc` in `pubspec.yaml`
- [ ] T002 [P] Establish strict linting constraints in `analysis_options.yaml` (if applicable)

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core application entry point scaffolding

**⚠️ CRITICAL**: Must scaffold before features.

- [ ] T003 Ensure `lib/main.dart` exists and runs a minimal `MaterialApp`
- [ ] T004 Build the global UI theme entry in `lib/core/theme/app_theme.dart` (Empty static class for now)

**Checkpoint**: Application boots up securely.

---

## Phase 3: User Story 3 - Structured File Discovery (Priority: P2)

**Goal**: Build the universal feature-based tree structure enabling predictable file tracking.

### Implementation for User Story 3

- [ ] T005 [P] [US3] Create directories `lib/core/constants/`, `lib/core/errors/`, `lib/core/theme/`, `lib/core/utils/`
- [ ] T006 [P] [US3] Create `lib/features/quiz/` layer directories: `data/`, `domain/`, and `presentation/`
- [ ] T007 [P] [US3] Under `features/quiz/data/`, create: `datasources/`, `models/`, and `repositories/`
- [ ] T008 [P] [US3] Under `features/quiz/domain/`, create: `entities/`, `repositories/`, and `usecases/`
- [ ] T009 [P] [US3] Under `features/quiz/presentation/`, create: `cubit/`, `pages/`, and `widgets/`

**Checkpoint**: The core folder constraint map is physically cemented in the repository to prevent "spaghetti" logic dropping.

---

## Phase 4: User Story 2 - SOLID Compliance (Priority: P1)

**Goal**: Force logical files to conform to base abstractions rather than raw types.

### Implementation for User Story 2

- [ ] T010 [P] [US2] Create abstract base `Failure` extending `Equatable` inside `lib/core/errors/failures.dart`
- [ ] T011 [P] [US2] Create specific failure types `ServerFailure` and `CacheFailure` inside `lib/core/errors/failures.dart`
- [ ] T012 [P] [US2] Create abstract generic class `UseCase<Type, Params>` utilizing `Future<Either<Failure, Type>>` in `lib/core/usecases/usecase.dart`

**Checkpoint**: Core domain abstractions are firmly available, ensuring Repositories and UseCases don't leak unpredictable network exceptions.

---

## Phase 5: User Story 1 - Layer Independence and Scalability (Priority: P1)

**Goal**: Route Data to Domain via clean Dependency Injection isolating the UI completely.

### Implementation for User Story 1

- [ ] T013 [P] [US1] Create the Dependency Injection core file `lib/injection/injection_container.dart`
- [ ] T014 [US1] Implement `final sl = GetIt.instance;` and an asynchronous `Future<void> init()` inside `injection_container.dart`
- [ ] T015 [US1] Update `lib/main.dart` to await the DI `init()` call prior to executing `runApp()`

**Checkpoint**: Structural inversion-of-control is ready. The architecture will flawlessly intercept all future abstraction bindings for the Quiz mode implementation.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Format validation

- [ ] T016 [P] Run `dart format lib/` to ensure structural alignment throughout the newly provisioned directory tree.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1 & 2)**: Triggers primary package resolution.
- **US3 Folder Structure (Phase 3)**: Physically provisions the bounds. Must precede any file creation tasks.
- **US2 Abstractions (Phase 4)**: Scaffolds the rules of engagement. Must precede US1 which dictates how they are injected.
- **US1 Service Locator (Phase 5)**: The final capstone tying the empty architecture mapping together.

### Format Validation Notice
This file complies exactly with the requested markdown checkmark format (`- [ ] TXXX [P] [Story]`) designed explicitly for automated downstream LLM workflow integrations.
