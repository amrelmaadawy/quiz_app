# Tasks: Design Patterns Implementation

**Input**: Design documents from `/specs/003-design-patterns/`
**Prerequisites**: plan.md, spec.md, data-model.md, research.md, quickstart.md

**Organization**: Tasks are grouped by architectural capability to enable isolated implementation. Absolute paths and hyper-specific instructions are designed continuously ensuring deterministic LLM generation execution.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Review available interfaces

- [ ] T001 Review `lib/core/usecases/usecase.dart` generic interface existence (Generated in Phase 2 logic)

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core logic scaffolding

- [ ] T002 Ensure `lib/features/quiz/domain/entities/question.dart` represents primitive map variables securely before routing UI implementation.

---

## Phase 3: User Story 2 - Abstract Data Provisioning and Generation (Priority: P1)

**Goal**: Abstract Data via factory parsing boundaries, resolving network to Domain dependencies safely.

### Implementation for User Story 2

- [ ] T003 [P] [US2] Generate abstract `QuizRepository` defining async methods in `lib/features/quiz/domain/repositories/quiz_repository.dart`
- [ ] T004 [US2] Implement `QuestionFactory` struct containing single `static Question create({required Map<String, dynamic> data})` method in `lib/features/quiz/domain/entities/question_factory.dart`
- [ ] T005 [US2] Create boundary class `QuizRepositoryImpl` explicitly `implements QuizRepository` in `lib/features/quiz/data/repositories/quiz_repository_impl.dart`

**Checkpoint**: Core domain data creation boundaries are cleanly encapsulated in generic classes.

---

## Phase 4: User Story 1 - Pluggable Quiz Strategies (Priority: P1)

**Goal**: Divert branching logic paths utilizing the polymorphic Strategy Pattern.

### Implementation for User Story 1

- [ ] T006 [P] [US1] Create strictly typed `QuizStrategy` abstract interface template inside `lib/core/usecases/quiz_strategy.dart`
- [ ] T007 [P] [US1] Create concrete `PracticeStrategy` leveraging `implements QuizStrategy` inside `lib/features/quiz/domain/usecases/practice_strategy.dart`
- [ ] T008 [P] [US1] Create concrete `ExamStrategy` leveraging `implements QuizStrategy` inside `lib/features/quiz/domain/usecases/exam_strategy.dart`
- [ ] T009 [P] [US1] Create concrete `RandomStrategy` leveraging `implements QuizStrategy` inside `lib/features/quiz/domain/usecases/random_strategy.dart`

**Checkpoint**: Strategy pattern templates are physically defined to eliminate spaghetti switch-case logic across UI layer tracking.

---

## Phase 5: User Story 3 - Singleton Services (Priority: P2)

**Goal**: Centralize intensive network resources securely via Global Service Locator memory bounds.

### Implementation for User Story 3

- [ ] T010 [P] [US3] Instantiate stubbed logic class `AIService` inside `lib/features/quiz/data/datasources/ai_service.dart`
- [ ] T011 [US3] Update `lib/injection/injection_container.dart` by adding `sl.registerLazySingleton(() => AIService());` exactly to control memory allocations globally
- [ ] T012 [US3] Also update `lib/injection/injection_container.dart` by registering all the concrete `QuizStrategy` implementations via `sl.registerFactory()` to support generic instance resolving.

**Checkpoint**: Application runtime guarantees precisely one operating instance of AI execution mechanics concurrently.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Verifiable execution constraints

- [ ] T013 [P] Ensure mocktail `QuestionFactoryTest` explicitly asserts JSON structural mappings securely in `test/features/quiz/domain/question_factory_test.dart`
- [ ] T014 Run validation ensuring `clean architecture` constraints aren't violated via IDE static analysis rules.

---

## Dependencies & Execution Order

### Phase Dependencies

- **US2 Data Abstracting (Phase 3)**: Forces decoupling of mapping mechanisms from local/remote sources BEFORE network logic goes wild.
- **US1 Pluggable States (Phase 4)**: Maps business execution paths independently.
- **US3 Injection Scaffolding (Phase 5)**: Explicitly glues interfaces together into memory mappings securely linking Phase 3 and 4 together via runtime resolution.

### Parallel Opportunities Identified
- Setting up concrete Strategies (T007, T008, T009) can be massively auto-generated entirely in parallel due to strict physical interface (`QuizStrategy`) isolations.

### Format Validation Notice
This file complies exactly with the requested markdown checkmark format (`- [ ] TXXX [P] [Story]`) designed explicitly for deterministic AI task tracking, guaranteeing cheaper agents won't trip over missing boundaries.
