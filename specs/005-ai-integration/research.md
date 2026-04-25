# Research: AI Integration Boundaries

## Decision: Data Transmission Mapping
- **Decision**: HTTP/REST transmission explicitly fetching `List<Map<String,dynamic>>` mappings dynamically.
- **Rationale**: While local Dart embeddings exist natively, dynamically polling a free-tier external REST endpoint (like Gemini/Claude) guarantees massive, unpredictable topic generation capability. `http` offers pure asynchronous threading capabilities that inherently trap TCP exceptions.
- **Alternatives considered**: Local SDK embeddings / WebSocket streams. Rejected. SDKs heavily bloat local app sizes, and streaming tokens per-character over Canvas UI creates severe state-thrashing overhead over a simple bulk payload return.

## Decision: Hallucination Defense (Markdown Stripping)
- **Decision**: Regex interception nested directly inside `RemoteAIDataSource`.
- **Rationale**: Many LLMs wrap JSON responses maliciously inside ` ```json \n [body] \n ``` ` regardless of strict system prompt instructions forbidding it. Directly attempting `jsonDecode(string)` will throw native format exceptions. Parsing `string.replaceAll('```json', '')` guarantees standard sanitization passively before throwing native validation exceptions securely over to `dartz` failures.
