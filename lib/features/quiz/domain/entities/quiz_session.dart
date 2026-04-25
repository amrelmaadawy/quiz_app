import 'package:equatable/equatable.dart';
import 'question.dart';

class Answer extends Equatable {
  final String questionId;
  final int selectedIndex;
  final bool isCorrect;

  const Answer({
    required this.questionId,
    required this.selectedIndex,
    required this.isCorrect,
  });

  @override
  List<Object> get props => [questionId, selectedIndex, isCorrect];
}

class QuizSession extends Equatable {
  final String id;
  final List<Question> questions;
  final List<Answer> answers;
  final DateTime startedAt;
  final DateTime? completedAt;

  const QuizSession({
    required this.id,
    required this.questions,
    required this.answers,
    required this.startedAt,
    this.completedAt,
  });

  QuizSession copyWith({
    String? id,
    List<Question>? questions,
    List<Answer>? answers,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return QuizSession(
      id: id ?? this.id,
      questions: questions ?? this.questions,
      answers: answers ?? this.answers,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  List<Object?> get props => [id, questions, answers, startedAt, completedAt];
}
