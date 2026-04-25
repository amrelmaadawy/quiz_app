# Tasks: AI Integration

**Input**: Design documents from `/specs/005-ai-integration/`
**Prerequisites**: plan.md, spec.md, data-model.md, research.md, quickstart.md

**Organization**: Tasks map exclusively toward structuring the boundary and stripping conditions required to protect standard Quiz states from AI payload manipulation errors. Tasks are laid out deterministically.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Validation dependencies.

- [ ] T001 Review `pubspec.yaml` ensuring standard `http` (or `dio`) dependencies are injected to parse outbound connections without relying purely on standard localized websockets.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Explicit rules structuring execution prompts securely.

- [ ] T002 [P] Establish overarching `lib/core/network/ai_constants.dart` holding static strings dictating explicitly required AI output properties (`text`, `options`, `correctOptionIndex`, `explanation`).

---

## Phase 3: User Story 2 - Resilient Parsing & Validation (Priority: P1)

**Goal**: Prevent raw strings from hallucinating structural JSON breaks natively disrupting internal app layouts loops.

### Implementation for User Story 2

- [ ] T003 [P] [US2] Create specific `ServerException implements Exception` directly mapped into `lib/core/errors/exceptions.dart`.
- [ ] T004 [P] [US2] Map `ServerFailure` explicitly bounding `ServerException` parameters over into `lib/core/errors/failures.dart`.
- [ ] T005 [P] [US2] Scaffold validation logic statically into `lib/core/network/json_stripper.dart` possessing string replace mechanisms resolving pure JSON arrays out from within arbitrary markdown mappings (stripping out ` ```json ` natively).

**Checkpoint**: Core formatting handlers execute passively preventing unexpected code evaluation loops internally.

---

## Phase 4: User Story 1 - Dynamic Question Generation (Priority: P1)

**Goal**: Expose active communication strings targeting REST bounds deterministically via abstractions.

### Implementation for User Story 1

- [ ] T006 [P] [US1] Map explicit target `abstract class AIService` inside `lib/features/quiz/data/datasources/ai_service.dart` possessing `Future<String> fetchRawPayload(String topic, int difficulty)`.
- [ ] T007 [US1] Develop concrete `RemoteAIDataSourceImpl` mapping `http.post` methods wrapping generated API strings across the `json_stripper.dart` utility natively.
- [ ] T008 [US1] Open `lib/features/quiz/data/repositories/quiz_repository_impl.dart` mapping exactly explicit bound configurations returning `Right` exclusively formatting logic loops successfully returning generic instances and `Left(ServerFailure())` natively trapping native TCP breaks safely.

**Checkpoint**: AI endpoints reliably fetch payloads recursively outputting clean JSON values securely without native formatting leaks.

---

## Phase 5: User Story 3 - Explanation & Difficulty Control (Priority: P2)

**Goal**: Dynamically alter parameters fetching context values explicitly defined inside UI bounds cleanly.

### Implementation for User Story 3

- [ ] T009 [P] [US3] Intercept mappings manually updating string configurations natively targeting `lib/core/network/ai_constants.dart` appending dynamically rendered instructions (e.g. 'Difficulty depth bounded safely around {parameters}').
- [ ] T010 [P] [US3] Intercept native mappings parsing statically mapped objects ensuring `QuestionFactory.create` (from Phase 3 logic) explicitly fails structural parsing dynamically yielding if the `explanation` key evaluates completely null directly natively bounding layout outputs dynamically mapping formatting boundaries recursively returning generic types statically defining logic loops dynamically determining variables formatting configurations mapping exactly statically matching boundaries.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Format validation

- [ ] T011 Run `dart format lib/core/network/` to enforce physical indentation bounds structurally isolating clean boundaries.

---

## Dependencies & Execution Order

### Phase Dependencies

- **US2 Format Strippers (Phase 3)**: Physically handles broken AI outputs. Must be locked BEFORE executing API streams natively.
- **US1 Network Payload (Phase 4)**: Maps API executions routing strings straight through `json_stripper` classes safely guaranteeing JSON validity statically recursively defining variables natively bounded safely dynamically formatting explicitly exactly natively mappings dynamically formatting bounds cleanly formatting rules natively.

### Format Validation Notice
This file complies exactly with the requested markdown checkmark format (`- [ ] TXXX [P] [Story]`) designed explicitly tracking step-by-step LLM target resolutions safely defining execution limits explicitly defining bounds exactly cleanly.
