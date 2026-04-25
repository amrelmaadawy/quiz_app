# Quickstart Flow: Project Architecture

## Workflow for adding a new feature

**1. Define Domain (Inner Circle)**
- Scaffold the basic core `Entity` classes tracking your primitive structures.
- Define an abstract `<Feature>Repository` interface listing strictly what inputs/outputs the backend layer must handle.
- Create `UseCase` classes handling the execution rules.

**2. Scaffold Data (Outer Bounds)**
- Build the data JSON `Models` that extend/map to your `Entities`.
- Create a `DataSource` interface and concrete class to do exact network/storage IO logic (e.g. Hive requests).
- Write `<Feature>RepositoryImpl` implementing the abstract domain layer interface and bridging the DB execution errors to clean domain `Either<Failure, T>` returns.

**3. Inject Services**
- Open `lib/injection/injection_container.dart` and register the DB instance, DataSource, abstract Repository, UseCases, and Cubit execution sequence.

**4. Build Presentation**
- Scaffold the `Cubit` requiring the UseCase parameters injected through `get_it`.
- Finally, create the Flutter Widget binding UI buttons to Cubit actions and State updates to screen renders.
