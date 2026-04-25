# Feature Specification: Quiz Core System

**Feature Branch**: `001-quiz-core-system`  
**Created**: 2026-04-20
**Status**: Draft  
**Input**: User description: "Phase 1 — System Definition (Spec-Driven)"

## User Scenarios & Testing

### User Story 1 - Practice Mode (Priority: P1)

Users can take a quiz in "Practice" mode, which provides immediate feedback and explanations for each question they answer, helping them learn design patterns iteratively.

**Why this priority**: Practice mode is the core learning loop of a design patterns quiz app.
**Independent Test**: Can be fully tested by launching a practice quiz, answering a question, and verifying the immediate explanation display.

**Acceptance Scenarios**:

1. **Given** a user is on the quiz setup screen, **When** they start a "Practice" quiz, **Then** they see the first multiple-choice question.
2. **Given** the user is answering a Practice question, **When** they select an option, **Then** the app immediately highlights the correct answer and displays the AI-generated explanation.

---

### User Story 2 - Exam Mode (Priority: P1)

Users can take a quiz in "Exam" mode to test their knowledge under test constraints without immediate feedback, receiving a final score at the end.

**Why this priority**: Exam mode validates the user's retained knowledge. 
**Independent Test**: Can be tested by completing a full standard quiz flow and verifying the final scoring logic.

**Acceptance Scenarios**:

1. **Given** a user is answering an Exam question, **When** they select an option, **Then** their choice is recorded without showing the correct answer or explanation, and they proceed to the next question.
2. **Given** the user completes the final Exam question, **When** they submit the quiz, **Then** a final Result summary is calculated and displayed.

---

### User Story 3 - Offline-First Execution (Priority: P1)

Users can take quizzes even when offline, as the application prioritizes local storage for both question retrieval and session state.

**Why this priority**: Real offline-first behavior enables uninterrupted user experience anywhere.
**Independent Test**: Can be tested by disabling device connectivity and confirming quizzes can fully initialize and complete.

**Acceptance Scenarios**:

1. **Given** the device has no internet connection, **When** the user starts a quiz, **Then** the questions load successfully and swiftly from the local database.

---

### User Story 4 - AI Question Generation (Priority: P2)

The system generates new design pattern questions and explanations via an AI service to ensure a constantly refreshed and expansive pool of MCQs.

**Why this priority**: Automates content creation so the app doesn't require hardcoded static content updates.
**Independent Test**: Can be tested by triggering the AI service and confirming questions adhere to the app's internal format and are saved locally.

**Acceptance Scenarios**:

1. **Given** the local question pool is inadequate, **When** new questions are requested from AI, **Then** valid, strictly-formatted MCQs are returned and stored in local storage for future quizzes.

## Requirements

### Functional Requirements

- **FR-001**: System MUST support three quiz modes: Practice, Exam, and Random.
- **FR-002**: System MUST present questions as Multiple Choice Questions (MCQs).
- **FR-003**: System MUST execute offline-first, loading and saving `QuizSession` and `Result` states to a local database.
- **FR-004**: System MUST integrate with an AI service that generates correctly structured MCQ questions and explanatory text.
- **FR-005**: System MUST perform UI updates and local data loads without blocking the main event thread (No UI blocking).
- **FR-006**: System MUST maintain isolated, fully testable business logic for quiz evaluation.

### Key Entities

- **Question**: Represents a single MCQ, including the question text, multiple choices, the correct choice id, and an AI-generated explanation.
- **Answer**: Represents the user's selected choice for a given question.
- **QuizSession**: Represents an active timeline of user answers, the active mode (Practice/Exam/Random), and internal progress state.
- **Result**: Represents the calculated outcome (score, duration) upon completion of a `QuizSession`.

## Success Criteria

### Measurable Outcomes

- **SC-001**: Local data loading (questions and sessions) takes less than 200ms, ensuring zero perceptible UI blocking.
- **SC-002**: AI generation strictly yields parsable JSON instances of the `Question` model, succeeding 99% of the time.
- **SC-003**: Core domain models (`Question`, `Result`, `QuizSession`) achieve 100% test coverage for their business logic methods.

## Assumptions

- Offline-first implies all possible assets to run a core quiz are cached before connectivity drops.
- AI integration entails standard REST or equivalent network requests that may fail or timeout; a fallback or cached subset must be used if AI is unreachable.
- "Random" mode will remix previously cached questions and randomly generated new ones.
