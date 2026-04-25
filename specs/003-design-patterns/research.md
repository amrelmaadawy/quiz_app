# Research: Design Patterns Configuration

## Decision: Quiz Mode Execution Logic
- **Decision**: Strategy Design Pattern for `QuizMode` (Practice, Exam, Random).
- **Rationale**: A large `switch(mode)` block in the presentation layer or standard UseCase class violates the Open/Closed Principle. Emitting different feedback (Ex: showing explanations instantly in Practice vs hiding them in Exam) requires disjointed logic flows best maintained in isolated classes `PracticeStrategy`, `ExamStrategy`. A developer can just add `TimedStrategy` later by implementing the same interface.
- **Alternatives considered**: Simple conditionals inside `QuizSession`. Rejected due to testing complexity and monolithic class bloating.

## Decision: Question Instantiation
- **Decision**: Factory Pattern `QuestionFactory.create(type, data)`
- **Rationale**: Since the AI could hypothetically return different JSON formats or multiple subtypes of Questions in the future, delegating `Question` parsing away from the Repository class directly into a dedicated builder function respects the Single Responsibility Principle.

## Decision: API Network Lifecycle
- **Decision**: `LazySingleton` configuration via `get_it` for `AIService`.
- **Rationale**: We must enforce exactly one active websocket, HTTP client queue, or processing queue to the remote LLM generator to prevent race conditions or severe API quota drains. Using `LazySingleton` delays the memory allocation purely until the user first taps 'Request AI Generation', unlike standard global Singletons.
