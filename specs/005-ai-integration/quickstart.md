# Quickstart Flow: AI Integration Logic

## Workflow for executing external payload loops

**1. Isolate the API Call (The Engine)**
- Open `lib/features/quiz/data/datasources/remote_ai_data_source.dart`.
- Inject your HTTP payload querying logic enforcing exactly explicit System Prompt configurations dictating schema output parameters.

**2. Cleanse and Deserialise (The Wash)**
- Before performing natively typed loops, dynamically parse the raw String via Regex parameters.
- ```dart
  final cleanString = rawApiResponse.replaceAll(RegExp(r'```(?:json)?|```'), '').trim();
  final List<dynamic> jsonList = jsonDecode(cleanString);
  ```

**3. Factory Desecration (The Guard)**
- Route the `jsonList` iteration into `QuestionFactory.create(data: listObject)`.
- If a parameter diverges, the Factory throws immediately preventing structurally dead variables permeating the UI layer safely.
