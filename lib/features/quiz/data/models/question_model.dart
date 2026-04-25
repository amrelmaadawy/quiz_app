import 'package:hive/hive.dart';
import '../../domain/entities/question.dart';

part 'question_model.g.dart';

@HiveType(typeId: 0)
class QuestionModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String text;

  @HiveField(2)
  final List<String> options;

  @HiveField(3)
  final int correctIndex;

  @HiveField(4)
  final String explanation;

  QuestionModel({
    required this.id,
    required this.text,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  factory QuestionModel.fromEntity(Question question) {
    return QuestionModel(
      id: question.id,
      text: question.text,
      options: question.options,
      correctIndex: question.correctIndex,
      explanation: question.explanation,
    );
  }

  Question toEntity() {
    return Question(
      id: id,
      text: text,
      options: options,
      correctIndex: correctIndex,
      explanation: explanation,
    );
  }
}
