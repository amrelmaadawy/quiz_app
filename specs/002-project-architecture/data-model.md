# Data Boundary Models: Project Architecture

*(Architectural relationships between structural constraints)*

## Layer Definitions

### `Presentation` Layer Component
- **Scope**: Exclusively Flutter code. Translates Domain pure data logic into visual pixels.
- **Rules**: Must NOT instantiate Repository or UseCase classes directly. Resolves through `get_it`. Cannot read/write JSON natively.
- **State Engine**: Uses `flutter_bloc` `Cubit` structure to emit mapped States.

### `Domain` Layer Component
- **Scope**: Exclusively pure Dart code. Exists as an isolated bubble containing zero Flutter dependencies.
- **Rules**: Defines the `Entities` required by the business logic, the `UseCases` orchestrating operations, and the abstract `Repositories` mapping I/O.
- **Dependencies**: Depends on NOTHING. Cannot import `data` or `presentation`.

### `Data` Layer Component
- **Scope**: Hybrid Dart. Translates external APIs, SDKs, and local DBs.
- **Rules**: Holds concrete `RepositoryImpl` classes fulfilling `Domain.Repositories`. Casts strict Network JSON models into pure `Entities`.

### `Core` Shared Scope
- **Scope**: Globals and Utilities.
- **Rules**: Common string sets `constants.dart`, unifier `failures.dart`, generic `usecase.dart` template. Keeps redundancies DRY.
