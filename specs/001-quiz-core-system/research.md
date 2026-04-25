# Research: Quiz Core System

## Decision: Local Storage Engine (Hive vs Isar vs SQLite)
- **Decision**: Hive
- **Rationale**: Hive provides rapid, synchronous NoSQL box storage which exactly aligns with the immediate read requirements (sub-200ms without blocking) for `Question`, `Answer`, and `QuizSession` local caches. It is purely dart-native and offline-first. SQLite involves heavy relational boilerplate that exceeds the needs of saving an array of MCQs and scores.
- **Alternatives considered**: Isar could be used for advanced querying but is slightly heavier and often requires native bindings which are overkill for basic offline quiz saving. SQLite/sqflite was rejected due to relational mapping complexity for simple JSON-like schemas.

## Decision: Data Source & AI Service Integration
- **Decision**: Abstract Repository with Multiple DataSources (`LocalDataSource`, `RemoteAIDataSource`).
- **Rationale**: Clean Architecture dictates that Domain should only know about an abstract `QuizRepository`. The Data layer will hold a unified `QuizRepositoryImpl` that sequences requests: check `LocalDataSource` for enough questions, and if deficient, trigger `RemoteAIDataSource` (the AI Service) to fetch and cache more.
- **Alternatives considered**: Directly accessing `AIService` from Cubit. Rejected due to SOLID and Clean Architecture constraints from Phase 2.

## Decision: Execution of Quiz Modes
- **Decision**: Strategy Design Pattern for Quiz Modes
- **Rationale**: The specs demand `Practice`, `Exam`, and `Random` modes with varying feedback mechanisms (immediate explanation vs final result). Using standard inheritance or large switch-case blocks violates Open-Closed Principle. A `QuizStrategy` interface (`PracticeStrategy`, `ExamStrategy`, `RandomStrategy`) injected into the session state evaluator safely decouples behavior.
- **Alternatives considered**: Resolving mode differences in the UI/Cubit layer. Rejected as UI must remain stateless regarding business validation logic.
