import '../../features/quiz/domain/entities/question.dart';

abstract class QuizStrategy {
  Answer evaluateAnswer(Question question, int selectedIndex);
  bool get showImmediateFeedback;
  bool get showExplanations;
}

class Answer {
  final String questionId;
  final int selectedIndex;
  final bool isCorrect;
  final String explanation;

  const Answer({
    required this.questionId,
    required this.selectedIndex,
    required this.isCorrect,
    required this.explanation,
  });
}
