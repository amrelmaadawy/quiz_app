import 'package:equatable/equatable.dart';

class Result extends Equatable {
  final String sessionId;
  final int correctCount;
  final int totalCount;
  final List<QuestionResult> questionResults;
  final DateTime completedAt;

  const Result({
    required this.sessionId,
    required this.correctCount,
    required this.totalCount,
    required this.questionResults,
    required this.completedAt,
  });

  double get percentage =>
      totalCount > 0 ? (correctCount / totalCount) * 100 : 0;

  String get grade {
    if (percentage >= 90) return 'A';
    if (percentage >= 80) return 'B';
    if (percentage >= 70) return 'C';
    if (percentage >= 60) return 'D';
    return 'F';
  }

  @override
  List<Object?> get props => [
    sessionId,
    correctCount,
    totalCount,
    questionResults,
    completedAt,
  ];
}

class QuestionResult extends Equatable {
  final String questionId;
  final String questionText;
  final int selectedIndex;
  final int correctIndex;
  final bool isCorrect;

  const QuestionResult({
    required this.questionId,
    required this.questionText,
    required this.selectedIndex,
    required this.correctIndex,
    required this.isCorrect,
  });

  @override
  List<Object?> get props => [
    questionId,
    questionText,
    selectedIndex,
    correctIndex,
    isCorrect,
  ];
}
