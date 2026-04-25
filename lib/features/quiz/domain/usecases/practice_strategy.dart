import '../../../../core/usecases/quiz_strategy.dart';
import '../entities/question.dart';

class PracticeStrategy implements QuizStrategy {
  @override
  bool get showImmediateFeedback => true;

  @override
  bool get showExplanations => true;

  @override
  Answer evaluateAnswer(Question question, int selectedIndex) {
    final isCorrect = selectedIndex == question.correctIndex;

    return Answer(
      questionId: question.id,
      selectedIndex: selectedIndex,
      isCorrect: isCorrect,
      explanation: question.explanation,
    );
  }
}
