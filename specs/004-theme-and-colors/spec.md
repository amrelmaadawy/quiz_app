# Feature Specification: Theme & Colors Separation

**Feature Branch**: `004-theme-and-colors`  
**Created**: 2026-04-20
**Status**: Draft  
**Input**: User description: "Phase 4 — Theme & Colors Separation"

## User Scenarios & Testing

### User Story 1 - Universal Color Palette (Priority: P1)

Developers and UI framework elements rely exclusively on a centralized color dictionary rather than hardcoded hex values, ensuring a scalable and uniform visual identity.

**Why this priority**: Eliminating hardcoded hex codes prevents design debt and enables trivial comprehensive visual redesigns (e.g., swapping a primary color updates the entire app globally).
**Independent Test**: Conduct a static analysis string search for `Color(0x` or `Colors.` across all presentation/UI files and verify 0 occurrences outside of the `app_colors.dart` registry.

**Acceptance Scenarios**:

1. **Given** a developer is styling a new button or text widget, **When** they apply a color, **Then** they reference `AppColors.primary` (or similar constants) instead of raw color codes.
2. **Given** the branding requirements change, **When** the hex value in `app_colors.dart` is modified, **Then** all corresponding UI elements automatically update across the entire application interface.

---

### User Story 2 - Centralized App Theme Registry (Priority: P1)

Flutter's global `ThemeData` is constructed entirely within `app_theme.dart` mapping the palette tokens, standardizing font behaviors and primitive UI component shapes globally.

**Why this priority**: Removes repetitive inline styling on widgets (like padding, border radius, and text styles), condensing styling into the master `MaterialApp` root.
**Independent Test**: Inject `AppTheme.lightTheme` into the global `MaterialApp` and verify native text or button widgets render with correct primary branding without localized overriding.

**Acceptance Scenarios**:

1. **Given** the application initializes, **When** `MaterialApp` boots, **Then** it seamlessly mounts the global `ThemeData` exported by the core layer.

## Requirements

### Functional Requirements

- **FR-001**: System MUST declare all color variables statically inside `core/theme/app_colors.dart`.
- **FR-002**: System MUST expressly forbid the direct usage of inline hardcoded `Color()` objects within any file governed by the `presentation/` bounded context.
- **FR-003**: System MUST define the global styling matrix via native Flutter `ThemeData` hosted exclusively in `core/theme/app_theme.dart`.
- **FR-004**: System MUST map the constants from `app_colors` into the varying `ThemeData` constructs to preserve unified inheritance bounds.

### Key Entities

*(Architectural Config Mapping)*
- **AppColors**: A purely static dictionary mapping semantic style names (primary, secondary, background, text) to underlying platform Hex bounds.
- **AppTheme**: A factory class generating overarching `ThemeData` rules.

## Success Criteria

### Measurable Outcomes

- **SC-001**: Zero linting violations for manually hardcoded `Color` objects inside `lib/features/`.
- **SC-002**: Centralized extraction maps exactly to the `PLAN.md` specification rules (100% adherence to abstraction rules).

## Assumptions

- We are initially focusing on a unified single theme (Light mode). Support for extensive generic Dark Modes is deferred unless explicitly required, though the structure easily permits expansion.
