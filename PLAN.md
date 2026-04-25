# Flutter Quiz App (Design Patterns) — Development Plan

---

## Phase 1 — System Definition (Spec-Driven)

### Files

* product_spec.md
* architecture_spec.md
* feature_quiz.md

### Define

* App type: Design Patterns Quiz
* Modes:

  * Practice
  * Exam
  * Random
* Question type: MCQ (initial)
* Offline-first (local storage)
* AI role: generate questions + explanations

### Core Models

* Question
* Answer
* QuizSession
* Result

### Non-Functional

* Fast performance
* No UI blocking
* Fully testable logic

---

## Phase 2 — Project Architecture (Clean Architecture)

### Folder Structure

```
lib/
 ├── core/
 │    ├── constants/
 │    ├── theme/
 │    ├── errors/
 │    └── utils/
 │
 ├── features/
 │    └── quiz/
 │         ├── data/
 │         ├── domain/
 │         └── presentation/
 │
 ├── injection/
 └── main.dart
```

### Layers

* Presentation → UI + Cubit
* Domain → Entities + UseCases
* Data → Repositories + DataSources

### SOLID Rules

* Single Responsibility per class
* Open for extension, closed for modification
* Use abstractions (interfaces)
* No direct dependency on implementations

---

## Phase 3 — Design Patterns

### Repository Pattern

* QuizRepository (abstract)
* QuizRepositoryImpl

### Factory Pattern

```
QuestionFactory.create(type, data)
```

### Strategy Pattern

```
QuizStrategy
 ├── PracticeStrategy
 ├── ExamStrategy
 ├── RandomStrategy
```

### Singleton

* AI Service instance

### Dependency Injection

* get_it for service locator

---

## Phase 4 — Theme & Colors Separation

### Files

```
core/theme/app_colors.dart
core/theme/app_theme.dart
```

### Example

```dart
class AppColors {
  static const primary = Color(0xFF1E88E5);
  static const secondary = Color(0xFF42A5F5);
  static const background = Color(0xFFF5F5F5);
}
```

Rule: No hardcoded colors in UI

---

## Phase 5 — AI Integration

### Service Interface

```dart
abstract class AIService {
  Future<List<Question>> generateQuestions(String topic);
}
```

### Responsibilities

* Generate questions
* Generate explanations
* Control difficulty

### Requirements

* Strict JSON output
* Validation before use
* Error handling

---

## Phase 6 — Data Layer

### Data Sources

```
LocalDataSource
RemoteAIDataSource
```

### Flow

* Load from local DB
* If empty → fetch from AI
* Cache results locally

### Storage

* Hive or Isar

---

## Phase 7 — State Management (Cubit)

### Cubit

```
QuizCubit
 ├── loadQuiz()
 ├── answerQuestion()
 ├── submitQuiz()
```

### State

```
QuizState
 ├── loading
 ├── loaded
 ├── error
```

Rule: No business logic inside UI

---

## Phase 8 — UI Screens

* Home Screen
* Quiz Setup Screen
* Quiz Screen
* Result Screen

### Rules

* UI only renders state
* No logic inside widgets
* All logic handled in Cubit/UseCases

---

## Phase 9 — Testing

### Unit Tests

* UseCases
* Repositories

### Widget Tests

* Quiz flow

### Mocking

* AI Service
* Repository

---

## Phase 10 — Development Workflow (Spec Loop)

For each feature:

1. Write spec
2. Validate spec
3. Implement
4. Test
5. Refactor

Rule: No feature without spec

---

## Phase 11 — Future Improvements

* Code-based questions
* Leaderboard system
* Spaced repetition
* Multi-language support
* AI adaptive difficulty

---

## Strict Constraints

* No API calls in UI
* No hardcoded colors or strings
* All models immutable
* Depend on abstractions only
* Separate concerns strictly
* Every feature tied to spec before implementation

---
