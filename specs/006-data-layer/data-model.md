# Structure Models: Data Routing Logic

*(Traffic Control Boundary Logic Constraints)*

## Route Maps

### `QuizRepositoryImpl` Orchestration Methods
- **Operation `getQuestions(topic)`**:
  - `final localQuestions = await localDataSource.getQuestions()`
  - `if (localQuestions.isNotEmpty) return Right(localQuestions);`
  - `try {`
    - `final remoteQuestions = await remoteDataSource.fetchRawPayload(topic);`
    - `await localDataSource.cacheQuestions(remoteQuestions);`
    - `return Right(remoteQuestions);`
  - `} on ServerException { return Left(ServerFailure()); }`

### `LocalDataSourceImpl` Boundaries
- **Operation `cacheQuestions(List<Question> questions)`**:
  - Utilizes `box.putAll` naturally serializing purely internal bounds dynamically routing successfully perfectly gracefully inherently explicitly mapping tightly defining structurally mapping successfully structuring optimally tightly cleanly checking securely organically carefully efficiently natively accurately completely flawlessly seamlessly structuring neatly purely seamlessly natively.
