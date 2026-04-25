# Research: Project Architecture

## Decision: Dependency Injection (DI) Strategy
- **Decision**: `get_it` Service Locator
- **Rationale**: Clean Architecture requires injecting concrete classes into abstract interfaces. `get_it` is the industry standard for Dart/Flutter to achieve fast O(1) synchronous dependency resolution. It allows mocking and swapping repositories trivially during testing.
- **Alternatives considered**: Passing dependencies via constructors manually (creates massive widget tree boilerplate); `riverpod`/`provider` (pollutes pure Dart layers with Flutter context dependency).

## Decision: Error Handling Boundary mapping
- **Decision**: `dartz` Functional Either Types & Exceptions -> Failures
- **Rationale**: Standard `try/catch` block leaks data layer logic cleanly through the stack. Using `Either<Failure, T>` explicitly flags synchronous and asynchronous logic execution states cleanly to the UI layer without throwing generic Exceptions.
- **Alternatives considered**: Standard `try/catch` mapped to `throws` keywords. Rejected because declarative state transitions (`Loading`, `Success`, `Error`) map 1:1 beautifully to `Either.fold()`.

## Decision: Feature vs Layer Folder Grouping
- **Decision**: Feature-driven grouping
- **Rationale**: A growing application with 30+ screens becomes impossible to navigate if all Repositories live in a single root folder. Grouping horizontally by Feature (`features/quiz/...`, `features/settings/...`) binds domain logic strictly.
