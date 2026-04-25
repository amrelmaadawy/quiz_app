# Implementation Plan: AI Integration

**Branch**: `005-ai-integration` | **Date**: 2026-04-20 | **Spec**: [spec.md](spec.md)

## Summary

This architectural iteration implements the explicit `AIService` boundary inside the Local/Remote hybrid architecture. It enforces severe logical constraints (regex trimming, structured JSON expectations, exception bridging) shielding the pure Domain from hallucinated outputs.

## Technical Context

**Language/Version**: Dart
**Primary Dependencies**: `http` (or `dio`), `dartz`
**Testing**: mocktail
**Project Type**: Feature Module Enhancements
**Constraints**: 
- The AI interface executes as an external, unstable data source.
- Responses MUST be meticulously validated against internal `Question` definitions before releasing data across the framework state boundaries.
- Uses explicit string-sanitization Regex algorithms trapping ` ```json ` bounding blocks.

## Constitution Check

*GATE: Passed. Complies with SOLID. Validations trap at the outer boundary (Data Layer) protecting the UseCase orchestrations.*

## Project Structure

### Documentation (this feature)

```text
specs/005-ai-integration/
├── plan.md              # This file
├── research.md          # Architecture decisions
├── data-model.md        # Object bounds
└── quickstart.md        # Scaffolding guide
```

### Source Code (repository root)

```text
lib/
├── core/
│   ├── errors/
│   │   ├── exceptions.dart        # ServerException bound mapping
│   │   └── failures.dart          # ValidationFailure parsing bound
│   └── network/
│       └── ai_constants.dart      # Strict internal system JSON instructions
└── features/
    └── quiz/
        ├── data/
        │   └── datasources/
        │       ├── remote_ai_data_source.dart  # Concrete AI execution loop
        │       └── ai_service.dart             # Abstract AI provider definition
        └── domain/
            └── repositories/
                └── quiz_repository.dart        # Bridging abstraction
```

**Structure Decision**: Confined to the `data/datasources/` sector. Network configurations isolate gracefully away from UseCases.
