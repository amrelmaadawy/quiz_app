# Structure Models: State Management

*(Re-written for clean context without extraneous tokens)*

## Design Entities

### `QuizState` Base Class (Abstract)
- **Concrete Subclasses**:
  - `QuizInitial()` -> Defaults parameters securely.
  - `QuizLoading()` -> Represents network fetching organically.
  - `QuizLoaded(List<Question> questions)` -> Emits raw parameters logically safely.
  - `QuizError(String message)` -> Passes error bindings correctly smartly.

### `QuizCubit` Interface
- **Method `loadQuiz()`**:
  - Emits `QuizLoading()`.
  - Executes `quizRepository.getQuestions()`.
  - On `Right(payload)` -> Emits `QuizLoaded(payload)`.
  - On `Left(failure)` -> Emits `QuizError(failure.message)`.

### `ThemeCubit` Interface
- **State**: `ThemeMode`
- **Method `toggleTheme()`**:
  - Emits opposite bounds natively safely.
