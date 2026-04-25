# Quickstart Flow: Theme & Colors Implementation

## Workflow for modifying the visual aesthetic

**1. Modify Local Palette Blocks**
- Open `lib/core/theme/app_colors.dart`.
- Change a target value, e.g. `static const primary = Color(0xFFE91E63);`
- Doing this systematically adjusts every primary focal point safely without risking UI regression.

**2. Hydrate Interface Overrides**
- If an entirely new Flutter widget looks wrong (e.g., standard Dialogs), DO NOT overwrite the background directly inside your Presentation page.
- Open `lib/core/theme/app_theme.dart` and bind a global override leveraging the unified `AppColors` registry:
```dart
dialogTheme: const DialogTheme(
  backgroundColor: AppColors.background,
  shape: RoundedRectangleBorder(
    // Global rounded corner standards
  ),
),
```

**3. Reference Explicitly via Context**
- Always rely on the inherent tree bindings rather than passing colors statically when overriding minor details locally:
```dart
Text('Example', style: Theme.of(context).textTheme.bodyLarge)
```
