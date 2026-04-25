# Quickstart Flow: Design Patterns Implementation

## Workflow for adding a new Quiz Mode

**1. Create the Strategy**
- Scaffold a new Dart class targeting the `QuizStrategy` interface inside `lib/features/quiz/domain/usecases/`.
```dart
class TimedStrategy implements QuizStrategy {
  // Define strict behaviors internally
}
```

**2. Hydrate Interface Dependencies**
- Expose the selection capability securely in your `QuizMode` Enum.
- Update your global `get_it` Service Locator routing the mode directly to your instantiated Strategy.
```dart
switch (mode) {
    case QuizMode.timed:
        return sl<TimedStrategy>();
    // ...
}
```

**3. Enjoy Zero UI Modifications**
- The UI layer strictly looks for `QuizStrategy.evaluate()`. It fires successfully without knowing it just triggered a `TimedStrategy` under the hood. No presentation logic refactoring required!
