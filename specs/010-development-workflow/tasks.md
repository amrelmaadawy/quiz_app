# Tasks: Development Workflow Governance

**Input**: Design documents from `/specs/010-development-workflow/`
**Prerequisites**: plan.md, spec.md, data-model.md, research.md, quickstart.md

**Organization**: Target execution logic updating the root AI configuration parameters to strictly prohibit hallucinatory drift.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2)

---

## Phase 1: User Story 1 - Strict Governance Architecture (Priority: P1)

**Purpose**: Formalize architecture tracking restrictions directly inside the underlying system model.

- [ ] T001 [P] [US1] Open `CLAUDE.md` in the root directory.
- [ ] T002 [US1] Add a master top-level header titled `### Master Governance Rule`. 
- [ ] T003 [US1] Inject the explicit sentence constraint: "NO FEATURE WILL BE CODED WITHOUT A SPEC. If the user asks for a new Dart implementation directly, you MUST redirect them to generate a specification first via `@[.claude/skills/speckit-specify]`."

---

## Phase 2: User Story 2 - Precondition Gating (Priority: P1)

**Goal**: Bind execution securely avoiding unstructured file bloat.

- [ ] T004 [P] [US2] Inside `CLAUDE.md`, locate the rules section governing Flutter architecture.
- [ ] T005 [US2] Append a strict structural directive: "Refuse to modify `lib/` files based on vague prompts. All modifications must directly map to an existing Checkbox Node inside `specs/XXX/tasks.md`."

---

## Dependencies & Execution Order

### Format Validation Notice
This file complies exactly with the macro testing limits. Ensure the cheaper LLM immediately executes updates to `CLAUDE.md` before coding any interface layouts.
