# Structure Models: AI Integration

*(Defining interface interaction logic)*

## Design Entities

### `AIService` (Abstract Bound)
- **Role**: Defines internal system-capable actions without revealing explicit payload HTTP configurations.
- **Method**: 
  - `Future<String> fetchRawPayload(String topic, int difficulty)`

### `RemoteAIDataSource` (Abstract Data Interface)
- **Role**: Connects abstract API logic to native domain payload arrays securely.
- **Method**:
  - `Future<List<QuestionModel>> fetchAIQuestions(String topic)` -> Translates native strings using Regex formatting, looping natively utilizing `QuestionFactory.create(data)` internally. Throws `ServerException` aggressively on JSON parsing bounds.

### `QuizRepositoryImpl` (Validation Integrator)
- **Role**: The centralized traffic cop. Uses `Either` error mappings natively bridging ServerExceptions mapping directly into presentation-facing `ValidationFailure` definitions cleanly.
- **Mapping Constraint**: `try { return Right(await remoteDataSource.fetchAIQuestions()); } on ServerException { return Left(ServerFailure()); }`
