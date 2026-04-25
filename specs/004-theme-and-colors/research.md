# Research: Theme & Colors Configuration

## Decision: Static Color Token Referencing
- **Decision**: Structuring `AppColors` as a pseudo-namespace featuring exclusively `static const` fields.
- **Rationale**: Flutter widgets rely on tight memory allocation. Passing instantiated color configuration objects forces boilerplate DI injections down the UI tree manually. Static constants (`AppColors.primary`) compute at compile time and map instantly inside rendering queues without increasing state memory allocations.
- **Alternatives considered**: Passing a dynamic `ThemeConfiguration` JSON map. Rejected because the specs only dictate a standardized layout rather than an API-driven white-label dynamic theming engine.

## Decision: Application of ThemeData
- **Decision**: Mapping standard `MaterialApp` structures using `AppTheme.lightTheme`.
- **Rationale**: Re-inventing styling tokens inside local `Container` or `Text` widgets scatters UI design tracking. Binding global font families, `appBarTheme` elevations, and `primaryColor` defaults at the root level inherently sanitizes every generated Flutter widget natively.
