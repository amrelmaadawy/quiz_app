import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import '../../../../core/errors/failures.dart';
import '../models/question_model.dart';
import '../models/quiz_session_model.dart';
import 'local_data_source.dart';

class LocalDataSourceImpl implements LocalDataSource {
  final Box<QuestionModel> questionBox;
  final Box<QuizSessionModel> sessionBox;

  LocalDataSourceImpl({required this.questionBox, required this.sessionBox});

  @override
  Future<Either<Failure, List<QuestionModel>>> getQuestions() async {
    try {
      final questions = questionBox.values.toList();
      if (questions.isEmpty) {
        final fallbacks = getFallbackQuestions();
        await saveQuestions(fallbacks);
        return Right(fallbacks);
      }
      return Right(questions);
    } catch (e) {
      return Left(CacheFailure('Failed to get questions: $e'));
    }
  }

  @override
  Future<Either<Failure, QuizSessionModel>> getQuizSession(
    int questionCount,
  ) async {
    try {
      var allQuestions = questionBox.values.toList();

      if (allQuestions.isEmpty) {
        final fallbacks = getFallbackQuestions();
        await saveQuestions(fallbacks);
        allQuestions = fallbacks;
      }

      final shuffled = List<QuestionModel>.from(allQuestions)..shuffle();
      final selectedQuestions = shuffled.take(questionCount).toList();

      final session = QuizSessionModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        questionIds: selectedQuestions.map((q) => q.id).toList(),
        answers: [],
        startedAt: DateTime.now(),
      );

      await sessionBox.put(session.id, session);
      return Right(session);
    } catch (e) {
      return Left(CacheFailure('Failed to create quiz session: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveQuestion(QuestionModel question) async {
    try {
      await questionBox.put(question.id, question);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to save question: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveQuestions(
    List<QuestionModel> questions,
  ) async {
    try {
      final map = {for (var q in questions) q.id: q};
      await questionBox.putAll(map);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to save questions: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveQuizSession(
    QuizSessionModel session,
  ) async {
    try {
      await sessionBox.put(session.id, session);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to save session: $e'));
    }
  }

  @override
  List<QuestionModel> getFallbackQuestions() {
    return [
      QuestionModel(
        id: 'fallback_1',
        text: 'What is the purpose of the Observer pattern?',
        options: const [
          'Encapsulate request as object',
          'Define one-to-many dependency',
          'Ensure single instance',
          'Add behavior dynamically',
        ],
        correctIndex: 1,
        explanation: 'Observer defines one-to-many dependency between objects.',
      ),
      QuestionModel(
        id: 'fallback_2',
        text: 'Which pattern ensures a class has only one instance?',
        options: const ['Singleton', 'Factory', 'Prototype', 'Builder'],
        correctIndex: 0,
        explanation: 'Singleton ensures a class has only one instance.',
      ),
      QuestionModel(
        id: 'fallback_3',
        text: 'What does the Factory pattern do?',
        options: const [
          'Creates objects without specifying exact class',
          'Provides global access point',
          'Separates algorithm from object',
          'Adds responsibilities dynamically',
        ],
        correctIndex: 0,
        explanation:
            'Factory provides interface for creating objects without specifying exact class.',
      ),
      QuestionModel(
        id: 'fallback_4',
        text:
            'Which pattern attaches responsibilities to an object dynamically?',
        options: const ['Decorator', 'Composite', 'Facade', 'Proxy'],
        correctIndex: 0,
        explanation:
            'Decorator attaches additional responsibilities dynamically.',
      ),
      QuestionModel(
        id: 'fallback_5',
        text: 'What is the main purpose of the Strategy pattern?',
        options: const [
          'Defines family of interchangeable algorithms',
          'Provides unified interface',
          'Converts interface to another',
          'Manages object creation',
        ],
        correctIndex: 0,
        explanation: 'Strategy defines a family of interchangeable algorithms.',
      ),
    ];
  }
}
