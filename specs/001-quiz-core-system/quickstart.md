# Quickstart Flow: Quiz Core System

1. **Initialization:**
   Upon app execution, `main.dart` initializes `get_it` dependency injection.
   The `LocalDataSource` (e.g., Hive Box) opens securely.

2. **Session Creation (UseCase):**
   User selects a Quiz Mode UI button.
   The View calls `QuizCubit.startQuiz(mode)`.
   Cubit executes `GetQuizSessionUseCase` which communicates with `QuizRepository`.
   Repository queries local storage for questions. If the pool is low (e.g., `< 10` unseen), an async background request to `RemoteAIDataSource` fetches more to local.

3. **In-Quiz Loop:**
   The `QuizStrategy` parses the UI loop based on the mode.
   In `Practice` mode, `AnswerQuestionUseCase` evaluates correctness and immediately returns `isCorrect` alongside the `explanation`.
   In `Exam` mode, responses are merely tracked in `QuizSession`.

4. **Completion:**
   Once all questions are answered, `SubmitQuizUseCase` finalizes the `QuizSession` into a `Result` entity.
   The App navigates to `ResultScreen` displaying score analytics.
