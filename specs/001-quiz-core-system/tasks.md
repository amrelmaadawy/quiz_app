# Tasks: Quiz Core System

**Input**: Design documents from `/specs/001-quiz-core-system/`
**Prerequisites**: plan.md, spec.md, data-model.md, research.md, quickstart.md

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story. Strict mapping to Clean Architecture phases ensures a cheaper LLM can complete these deterministically.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- File paths are exact and must be respected strictly.

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic dependencies

- [X] T001 Initialize Dart/Flutter `pubspec.yaml` with `flutter_bloc`, `get_it`, `dartz`, and `hive_flutter`
- [X] T002 [P] Create the layer folders for `core/`, `features/quiz/data/`, `features/quiz/domain/`, and `features/quiz/presentation/`
- [X] T003 Initialize Hive registry config in `lib/main.dart`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core logic and structures that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T004 Create standard `Failure` classes in `lib/core/errors/failures.dart`
- [X] T005 [P] Create `UseCase` contract in `lib/core/usecases/usecase.dart`
- [X] T006 [P] Set up Dependency Injection container scaffolding in `lib/injection/injection_container.dart`
- [X] T007 Define the global `QuizMode` enum (`Practice`, `Exam`, `Random`) in `lib/core/constants/enums.dart`
- [X] T008 Define the abstract `QuizRepository` interface in `lib/features/quiz/domain/repositories/quiz_repository.dart`

**Checkpoint**: Foundation ready - user story implementation can now begin.

---

## Phase 3: User Story 3 - Offline-First Execution (Priority: P1) 🎯 MVP Core

*Note: Data offline caching is sequenced first to act as the true unified state anchor for the domain models before UI needs them.*

**Goal**: Users can take quizzes even when offline, as the application prioritizes local storage for both question retrieval and session state.
**Independent Test**: Mock generating Questions via repository and validating they persist and retrieve from Hive.

### Implementation for User Story 3

- [X] T009 [P] [US3] Create `Question` entity in `lib/features/quiz/domain/entities/question.dart`
- [X] T010 [P] [US3] Create `Answer` and `QuizSession` entities in `lib/features/quiz/domain/entities/quiz_session.dart`
- [X] T011 [P] [US3] Create `QuestionModel` with Hive annotations in `lib/features/quiz/data/models/question_model.dart`
- [X] T012 [P] [US3] Create `QuizSessionModel` with Hive annotations in `lib/features/quiz/data/models/quiz_session_model.dart`
- [X] T013 [US3] Implement `LocalDataSource` abstract and Hive implementation in `lib/features/quiz/data/datasources/local_data_source.dart`
- [X] T014 [US3] Implement `GetQuizSessionUseCase` requiring offline local load in `lib/features/quiz/domain/usecases/get_quiz_session.dart`
- [X] T015 [US3] Implement `QuizRepositoryImpl` tying `LocalDataSource` in `lib/features/quiz/data/repositories/quiz_repository_impl.dart` (depends on T013, T008)

**Checkpoint**: At this point, the entire offline Model and core Data layer is functional.

---

## Phase 4: User Story 1 - Practice Mode (Priority: P1)

**Goal**: Users can take a quiz in "Practice" mode, which provides immediate feedback and explanations.
**Independent Test**: Complete a quiz session yielding immediate right/wrong UI feedback.

### Implementation for User Story 1

- [X] T016 [P] [US1] Define `QuizStrategy` interface in `lib/core/usecases/quiz_strategy.dart`
- [X] T017 [US1] Implement `PracticeStrategy` implementing correctness and explanation rules in `lib/features/quiz/domain/usecases/practice_strategy.dart`
- [X] T018 [US1] Create the `QuizCubit` and `QuizState` handling the loaded Session and emitting responses in `lib/features/quiz/presentation/cubit/quiz_cubit.dart`
- [X] T019 [US1] Build the interactive `PracticePage` UI dispatching Cubit events in `lib/features/quiz/presentation/pages/practice_page.dart`
- [X] T020 [US1] Register Practice Mode dependencies in `lib/injection/injection_container.dart`

**Checkpoint**: Practice mode is independently playable matching the local DB questions.

---

## Phase 5: User Story 2 - Exam Mode (Priority: P1)

**Goal**: Users can take a test in "Exam" mode without immediate feedback, receiving a final score.

### Implementation for User Story 2

- [X] T021 [P] [US2] Create `Result` entity in `lib/features/quiz/domain/entities/result.dart`
- [X] T022 [US2] Implement `ExamStrategy` (tracks answers silently) in `lib/features/quiz/domain/usecases/exam_strategy.dart`
- [X] T023 [US2] Implement `SubmitQuizUseCase` to calculate and return `Result` in `lib/features/quiz/domain/usecases/submit_quiz.dart`
- [X] T024 [US2] Build the `ExamPage` UI in `lib/features/quiz/presentation/pages/exam_page.dart`
- [X] T025 [US2] Build the summary `ResultPage` UI rendering total score in `lib/features/quiz/presentation/pages/result_page.dart`

**Checkpoint**: Both quiz flavors are active with distinct calculation mechanics cleanly isolated via Strategy.

---

## Phase 6: User Story 4 - AI Question Generation (Priority: P2)

**Goal**: System generates new design pattern questions/explanations via AI.

### Implementation for User Story 4

- [X] T026 [P] [US4] Implement `RemoteAIDataSource` JSON fetching and parsing logic in `lib/features/quiz/data/datasources/remote_ai_data_source.dart`
- [X] T027 [US4] Modify `QuizRepositoryImpl` to request AI data when `LocalDataSource` runs critically low on unseen questions
- [X] T028 [US4] Expose manual trigger in Cubit and create `AiGenerationButton` widget in `lib/features/quiz/presentation/widgets/ai_generation_button.dart`

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [X] T029 [P] Write unit tests for `PracticeStrategy` evaluation in `test/features/quiz/domain/practice_strategy_test.dart`
- [X] T030 [P] Write bloc tests for `QuizCubit` transition states in `test/features/quiz/presentation/quiz_cubit_test.dart`
- [X] T031 Provide fallback offline dummy questions if AI generation fails and storage is empty in `lib/features/quiz/data/datasources/local_data_source.dart`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **US3 Offline Data (Phase 3)**: Serves as the bedrock repository layer for the rest of the application
- **US1 & US2 (Phases 4-5)**: Rely on Domain entities and Data layer built in US3. Can run sequentially or concurrently.
- **US4 AI Generation (Phase 6)**: Plugs directly into Phase 3's repo layer.

### Parallel Opportunities Identified
- Setting up Entities (T009, T010, T011, T012) can be rapidly distributed or auto-completed as independent POJO files.
- UI elements (T019, T024, T025) can be scaffolded visually prior to Cubit completion using Mock Cubits.

### Format Validation Notice
This file complies exactly with the requested markdown checkmark format (`- [ ] TXXX [P] [Story]`) to ensure seamless execution by secondary lower-capability agents tracking regex patterns.
