# Data Models: Quiz Core System

## Entities

### `Question`
*The fundamental Multiple Choice Question item.*
- **id** (String): Unique identifier (hash/UUID).
- **text** (String): The question content.
- **options** (List<String>): List of possible answer choices.
- **correctOptionIndex** (int): The 0-based index targeting the correct option.
- **explanation** (String): AI-generated explanation detailing why the correct option is correct.

### `QuizSession`
*The active state of a user taking a quiz.*
- **id** (String): Session trace ID.
- **mode** (Enum: PRACTICE, EXAM, RANDOM): The active quiz format.
- **questions** (List<Question>): The ordered list of questions targeted for this session.
- **answers** (Map<String, int>): A mapping of `Question.id` to the selected index.
- **isCompleted** (bool): Flag denoting end-of-session.

### `Result`
*The final computed outcome.*
- **sessionId** (String): Corresponds to the originating QuizSession.
- **totalQuestions** (int): Length of the session.
- **correctAnswers** (int): Number of correctly matched answers.
- **scorePercentage** (double): Derived percentage (0.0 to 100.0).

## Validation Rules
- `correctOptionIndex` MUST be `>= 0` and `< options.length`.
- `questions` array in a `QuizSession` must have length `> 0` to be valid.
- `Answer` submission to a `QuizSession` ensures the target `Question.id` exists in the local queue.
