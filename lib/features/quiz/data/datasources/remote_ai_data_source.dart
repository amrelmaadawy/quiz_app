import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../models/question_model.dart';

abstract class RemoteAIDataSource {
  Future<Either<Failure, List<QuestionModel>>> generateQuestions(int count, {String topic = ''});
}

class RemoteAIDataSourceImpl implements RemoteAIDataSource {
  final http.Client client;
  final String apiUrl;

  RemoteAIDataSourceImpl({required this.client, required this.apiUrl});

  @override
  Future<Either<Failure, List<QuestionModel>>> generateQuestions(
    int count, {String topic = ''}
  ) async {
    try {
      final response = await client
          .post(
            Uri.parse(apiUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'prompt':
                  'Generate $count multiple choice questions about ${topic.isEmpty ? 'software design patterns' : topic}. Each question should have 4 options, one correct answer, and an explanation. Format as JSON array.',
              'count': count,
            }),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        final questions = data.map((item) => _parseQuestion(item)).toList();
        return Right(questions);
      } else {
        return Left(
          ServerFailure('Failed to generate questions: ${response.statusCode}'),
        );
      }
    } catch (e) {
      return Left(NetworkFailure('Network error: $e'));
    }
  }

  QuestionModel _parseQuestion(Map<String, dynamic> json) {
    return QuestionModel(
      id:
          json['id']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      text: json['question'] ?? json['text'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctIndex: json['correctIndex'] ?? json['correct_index'] ?? 0,
      explanation: json['explanation'] ?? '',
    );
  }
}

class MockAIDataSourceImpl implements RemoteAIDataSource {
  @override
  Future<Either<Failure, List<QuestionModel>>> generateQuestions(
    int count, {String topic = ''}
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    final mockQuestions = [
      QuestionModel(
        id: 'ai_1_${DateTime.now().millisecondsSinceEpoch}',
        text: 'What is the core concept behind ${topic.isEmpty ? 'software design patterns' : topic}?',
        options: ['It is a specific programming language', 'It provides a general reusable solution', 'It is a database structure', 'It is a UI framework'],
        correctIndex: 1,
        explanation: 'A core concept is providing a general, reusable solution to common problems.',
      ),
      QuestionModel(
        id: 'ai_2_${DateTime.now().millisecondsSinceEpoch}',
        text: 'Which of the following is an essential benefit of learning about ${topic.isEmpty ? 'design patterns' : topic}?',
        options: [
          'It makes code run faster',
          'It improves code maintainability and communication',
          'It replaces the need for testing',
          'It compiles automatically',
        ],
        correctIndex: 1,
        explanation: 'It primarily improves maintainability and gives developers a shared vocabulary.',
      ),
      QuestionModel(
        id: 'ai_3_${DateTime.now().millisecondsSinceEpoch}',
        text: 'When should you typically apply ${topic.isEmpty ? 'these patterns' : topic}?',
        options: ['Every time you write code', 'When a specific recurring problem arises', 'Only in Java', 'When the compiler throws an error'],
        correctIndex: 1,
        explanation: 'They should be applied when you encounter the specific recurring problem they are designed to solve.',
      ),
      QuestionModel(
        id: 'ai_4_${DateTime.now().millisecondsSinceEpoch}',
        text: 'What is a common pitfall when using ${topic.isEmpty ? 'design patterns' : topic}?',
        options: ['Over-engineering a simple problem', 'Writing too few lines of code', 'It forces object-oriented programming', 'It requires external libraries'],
        correctIndex: 0,
        explanation: 'A common pitfall is over-engineering by applying complex solutions to simple problems.',
      ),
      QuestionModel(
        id: 'ai_5_${DateTime.now().millisecondsSinceEpoch}',
        text: 'How does ${topic.isEmpty ? 'this topic' : topic} relate to software architecture?',
        options: ['It is the same thing', 'It solves micro-level design problems', 'It defines the server infrastructure', 'It is irrelevant'],
        correctIndex: 1,
        explanation: 'It generally solves micro-level, component-based design problems rather than system-wide architecture.',
      ),
    ];

    return Right(mockQuestions.take(count).toList());
  }
}
