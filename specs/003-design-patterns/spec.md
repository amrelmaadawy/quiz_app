# Feature Specification: Design Patterns Implementation

**Feature Branch**: `003-design-patterns`  
**Created**: 2026-04-20
**Status**: Draft  
**Input**: User description: "Phase 3 — Design Patterns"

## User Scenarios & Testing

*(Note: For architectural specifications, the "User" represents the developer/system interacting with the architecture logic)*

### User Story 1 - Pluggable Quiz Strategies (Priority: P1)

Developers can implement or modify variations of Quiz execution (e.g., Practice vs Exam rules) without modifying the central UI or Domain iteration logic.

**Why this priority**: Enforces the Open/Closed Principle and defines the core logic boundary for varied quiz modes.
**Independent Test**: Introduce a new mock strategy and confirm it applies distinct rules to answer processing without altering core `QuizSession` tracking.

**Acceptance Scenarios**:

1. **Given** a Practice mode quiz, **When** an answer is submitted, **Then** the `PracticeStrategy` immediately returns correctness and explanation text.
2. **Given** an Exam mode quiz, **When** an answer is submitted, **Then** the `ExamStrategy` processes the completion status silently without leaking immediate explanations.

---

### User Story 2 - Abstract Data Provisioning and Generation (Priority: P1)

The system delegates all physical data retrieval to decoupled Repositories and controls instantiation of specific models via a centralized Factory.

**Why this priority**: Unifies object creation and abstracts local database/Network operations away from use cases.
**Independent Test**: Mock the `QuizRepository` interface in tests to force standard factory `Question` responses without triggering network logic.

**Acceptance Scenarios**:

1. **Given** the app requires loading a list of Multiple Choice Questions, **When** the internal request is made via JSON mapping, **Then** the `QuestionFactory` guarantees valid, standardized native `Question` representations are created.
2. **Given** network constraints occur, **When** the `QuizRepositoryImpl` attempts remote AI fetching, **Then** failure behaviors are trapped in the concrete implementation while preserving the interface.

---

### User Story 3 - Singleton Services (Priority: P2)

Resource-heavy or state-locking services (such as an overarching background AI service engine) execute dynamically via an isolated Singleton constraint.

**Why this priority**: Prevents redundant allocations, multi-threading conflicts, or excess bandwidth usage.
**Independent Test**: Request the AI Service reference mutually exclusively across three different scopes and ascertain they point to identical memory instances without reinstantiation.

**Acceptance Scenarios**:

1. **Given** the dependency injection is initialized, **When** an AI query is triggered concurrently, **Then** a singular global instance resolves the requests predictably.

## Requirements

### Functional Requirements

- **FR-001**: System MUST dictate all question retrieval boundaries through an abstract `QuizRepository` backed by `QuizRepositoryImpl`.
- **FR-002**: System MUST process variable Quiz Mode rules execution using the **Strategy Pattern** utilizing a master `QuizStrategy` interface (`PracticeStrategy`, `ExamStrategy`, `RandomStrategy`).
- **FR-003**: System MUST orchestrate all complex Data Model deserializations through a **Factory Pattern** (`QuestionFactory.create()`).
- **FR-004**: System MUST implement the external AI Service API as a strict **Singleton** resolving universally.
- **FR-005**: All pattern implementations MUST be wired dynamically into the system context via `get_it` Service Locator (**Dependency Injection**).

### Key Entities

*(Architectural Context mapping)*
- **QuizStrategy**: Polymorphic interface defining dynamic answer evaluation blocks.
- **QuizRepository**: Polymorphic interface mediating data sources arrays.
- **QuestionFactory**: Pure function logic dictating strictly controlled model allocations.

## Success Criteria

### Measurable Outcomes

- **SC-001**: 100% decoupling: the core evaluation loop does not contain `if (mode == Practice) else if`. Execution occurs purely via the bound Strategy reference.
- **SC-002**: Addition of a new Quiz rule variant (e.g. `TimedStrategy`) necessitates 0 specific alterations to the primary user interface widget state tracking.

## Assumptions

- Singleton pattern implementation relies strictly on `get_it.registerLazySingleton` rather than anti-pattern static class definitions.
