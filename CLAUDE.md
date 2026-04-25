# quiz1 Development Guidelines

Auto-generated from all feature plans. Last updated: 2026-04-21

## Active Technologies
- Dart + flutter_bloc, dartz, get_it, equatable (master)
- Dart + get_it (master)
- Dart + Flutter Material (`flutter/material.dart`) (master)
- Dart + `http` (or `dio`), `dartz` (master)
- Dart + `dartz`, `hive_flutter` (master)
- Dart + `flutter_bloc`, `equatable`, `dartz` (master)
- Dart + `flutter/material.dart`, `flutter_bloc` (master)
- Dart + `flutter_test`, `mocktail`, `bloc_test` (master)
- Markdown / Bash + `speckit-specify`, `speckit-plan`, `speckit-tasks` (master)

- Dart + flutter_bloc, get_it, dartz, hive_flutter (master)

## Project Structure

```text
src/
tests/
```

## Commands

# Add commands for Dart

## Code Style

Dart: Follow standard conventions

## Recent Changes
- master: Added Markdown / Bash + `speckit-specify`, `speckit-plan`, `speckit-tasks`
- master: Added Dart + `flutter_test`, `mocktail`, `bloc_test`
- master: Added Dart + `flutter/material.dart`, `flutter_bloc`


<!-- MANUAL ADDITIONS START -->

### Master Governance Rule

NO FEATURE WILL BE CODED WITHOUT A SPEC. If the user asks for a new Dart implementation directly, you MUST redirect them to generate a specification first via `@[.claude/skills/speckit-specify]`.

### Flutter Architecture Rules

- Refuse to modify `lib/` files based on vague prompts. All modifications must directly map to an existing Checkbox Node inside `specs/XXX/tasks.md`.

<!-- MANUAL ADDITIONS END -->
