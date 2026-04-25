# Implementation Plan: Theme & Colors Separation

**Branch**: `004-theme-and-colors` | **Date**: 2026-04-20 | **Spec**: [spec.md](spec.md)

## Summary

This architectural iteration centralizes all UI styling rules into the core layer. By completely segregating hex color values from presentation widgets, the application avoids design fragmentation and cleanly prepares for future overarching palette swaps.

## Technical Context

**Language/Version**: Dart
**Primary Dependencies**: Flutter Material (`flutter/material.dart`)
**Project Type**: Feature Module Enhancements
**Constraints**: 
- Absolute isolation of hex values inside `app_colors.dart`.
- `AppTheme` exclusively generates `ThemeData` root configurations without bleeding into state tracking.

## Constitution Check

*GATE: Passed. This separation of styling concerns adheres to the SOLID Single Responsibility constraint by stripping presentation logic widgets of their native responsibilities for evaluating hex-code variables.*

## Project Structure

### Documentation (this feature)

```text
specs/004-theme-and-colors/
├── plan.md              # This file
├── research.md          # Architecture decisions
├── data-model.md        # Object bounds
└── quickstart.md        # Scaffolding guide
```

### Source Code (repository root)

```text
lib/
├── core/
│   └── theme/
│       ├── app_colors.dart        # Immutable global color tokens
│       └── app_theme.dart         # Flutter ThemeData compiler
└── main.dart                      # Applies AppTheme root
```

**Structure Decision**: Confined entirely to the established `core/theme/` sector as per Phase 2.
