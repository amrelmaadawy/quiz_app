import 'package:hive/hive.dart';
import '../../domain/entities/quiz_session.dart';
import '../../domain/entities/question.dart';

part 'quiz_session_model.g.dart';

@HiveType(typeId: 1)
class AnswerModel extends HiveObject {
  @HiveField(0)
  final String questionId;

  @HiveField(1)
  final int selectedIndex;

  @HiveField(2)
  final bool isCorrect;

  AnswerModel({
    required this.questionId,
    required this.selectedIndex,
    required this.isCorrect,
  });

  factory AnswerModel.fromEntity(Answer answer) {
    return AnswerModel(
      questionId: answer.questionId,
      selectedIndex: answer.selectedIndex,
      isCorrect: answer.isCorrect,
    );
  }

  Answer toEntity() {
    return Answer(
      questionId: questionId,
      selectedIndex: selectedIndex,
      isCorrect: isCorrect,
    );
  }
}

@HiveType(typeId: 2)
class QuizSessionModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final List<String> questionIds;

  @HiveField(2)
  final List<AnswerModel> answers;

  @HiveField(3)
  final DateTime startedAt;

  @HiveField(4)
  final DateTime? completedAt;

  QuizSessionModel({
    required this.id,
    required this.questionIds,
    required this.answers,
    required this.startedAt,
    this.completedAt,
  });

  factory QuizSessionModel.fromEntity(
    QuizSession session,
    List<String> questionIds,
  ) {
    return QuizSessionModel(
      id: session.id,
      questionIds: questionIds,
      answers: session.answers.map((a) => AnswerModel.fromEntity(a)).toList(),
      startedAt: session.startedAt,
      completedAt: session.completedAt,
    );
  }

  QuizSession toEntity(List<Question> questions) {
    return QuizSession(
      id: id,
      questions: questions,
      answers: answers.map((a) => a.toEntity()).toList(),
      startedAt: startedAt,
      completedAt: completedAt,
    );
  }
}
