# Structure Models: Theme & Colors

*(Foundational Static UI Structuring)*

## Design Entities

### `AppColors` (Static Class namespace)
- **Role**: Exact mapping translation defining all Hex values active in the project workspace.
- **Tokens**:
  - `static const primary`
  - `static const secondary`
  - `static const background`
  - *(Derived)* semantic variants like `error`, `success`, `textPrimary`.

### `AppTheme` (Flutter Material Factory)
- **Role**: Combines constants from `AppColors` mapping them over Flutter's dense `ThemeData` API tree.
- **Bindings**: 
  - `static ThemeData get lightTheme` returning specific cascades affecting `AppBarTheme`, `ElevatedButtonThemeData`, `TextSelectionThemeData`, etc.
