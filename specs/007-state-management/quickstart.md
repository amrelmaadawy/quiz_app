# Quickstart Flow: Mapping Cubit Limits

## Developer Workflow for Expanding Data Storage Logic

**1. Isolate the Event Bounds**
- Open `lib/features/quiz/presentation/cubit/quiz_cubit.dart`.
- Any required asynchronous logic execution mappings (like generating more questions, or submitting an answer) must map explicitly here logically safely.

**2. Hydrate the Views**
- Open the UI Widget completely natively inside `lib/features/quiz/presentation/pages/`.
- ```dart
  BlocBuilder<QuizCubit, QuizState>(
    builder: (context, state) {
      if (state is QuizLoading) return CircularProgressIndicator();
      if (state is QuizLoaded) return Text(state.questions.first.text);
      if (state is QuizError) return Text(state.message);
      return SizedBox();
    }
  )
  ```
