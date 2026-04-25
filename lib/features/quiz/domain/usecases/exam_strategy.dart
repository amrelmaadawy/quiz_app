import '../../../../core/usecases/quiz_strategy.dart';
import '../entities/question.dart';

class ExamStrategy implements QuizStrategy {
  @override
  bool get showImmediateFeedback => false;

  @override
  bool get showExplanations => false;

  @override
  Answer evaluateAnswer(Question question, int selectedIndex) {
    final isCorrect = selectedIndex == question.correctIndex;

    return Answer(
      questionId: question.id,
      selectedIndex: selectedIndex,
      isCorrect: isCorrect,
      explanation: '',
    );
  }

  int getScore(List<Answer> answers) {
    return answers.where((a) => a.isCorrect).length;
  }
}
