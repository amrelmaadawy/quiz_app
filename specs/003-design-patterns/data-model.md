# Structure Models: Design Patterns

*(Polymorphic Interface requirements binding the patterns)*

## Design Entities

### `QuizStrategy` (Abstract Interface)
- **Role**: The template defining how a user's answer is evaluated.
- **Methods**: 
  - `Result evaluate(Answer answer, Question question)`
  - `bool get requiresImmediateFeedback()`

### `PracticeStrategy` (Concrete)
- **Behavior**: Evaluates `answer`, sets `isCorrect`, and returns an immediate data block including the `explanation`. Sets `requiresImmediateFeedback = true`.

### `ExamStrategy` (Concrete)
- **Behavior**: Evaluates `answer`, records the data payload for scoring at completion, explicitly suppresses explanation outputs. Sets `requiresImmediateFeedback = false`.

### `QuestionFactory` (Static Mapping Rule)
- **Role**: Validates and serializes foreign data into strict `Question` Dart entities.
- **Methods**: 
  - `static Question create({required Map<String, dynamic> data})`

### `AIService` (Singleton Bound)
- **Role**: Internal service interface ensuring solitary execution bounds.
- **Bound**: `getIt.registerLazySingleton<AIService>(() => AIServiceImpl());`
