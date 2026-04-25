import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../models/question_model.dart';

abstract class RemoteAIDataSource {
  Future<Either<Failure, List<QuestionModel>>> generateQuestions(int count);
}

class RemoteAIDataSourceImpl implements RemoteAIDataSource {
  final http.Client client;
  final String apiUrl;

  RemoteAIDataSourceImpl({required this.client, required this.apiUrl});

  @override
  Future<Either<Failure, List<QuestionModel>>> generateQuestions(
    int count,
  ) async {
    try {
      final response = await client
          .post(
            Uri.parse(apiUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'prompt':
                  'Generate $count multiple choice questions about software design patterns. Each question should have 4 options, one correct answer, and an explanation. Format as JSON array.',
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
    int count,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    final mockQuestions = [
      QuestionModel(
        id: 'ai_1',
        text:
            'Which design pattern provides a surrogate or placeholder for another object to control access to it?',
        options: ['Decorator', 'Proxy', 'Adapter', 'Facade'],
        correctIndex: 1,
        explanation:
            'The Proxy pattern provides a surrogate or placeholder for another object to control access to it.',
      ),
      QuestionModel(
        id: 'ai_2',
        text: 'What is the main purpose of the Command pattern?',
        options: [
          'Encapsulate a request as an object',
          'Define a skeleton algorithm',
          'Provide a unified interface to a set of interfaces',
          'Allow incompatible interfaces to work together',
        ],
        correctIndex: 0,
        explanation:
            'The Command pattern encapsulates a request as an object, thereby letting you parameterize clients with different requests.',
      ),
      QuestionModel(
        id: 'ai_3',
        text:
            'Which pattern is used to iteratively construct complex objects step by step?',
        options: ['Builder', 'Prototype', 'Abstract Factory', 'Singleton'],
        correctIndex: 0,
        explanation:
            'The Builder pattern lets you construct complex objects step by step, separating construction from representation.',
      ),
    ];

    return Right(mockQuestions.take(count).toList());
  }
}
