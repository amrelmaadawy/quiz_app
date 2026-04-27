import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/question.dart';
import '../../domain/entities/quiz_session.dart';
import '../../domain/repositories/quiz_repository.dart';
import '../datasources/local_data_source.dart';
import '../datasources/remote_ai_data_source.dart';
import '../models/question_model.dart';
import '../models/quiz_session_model.dart';

class QuizRepositoryImpl implements QuizRepository {
  final LocalDataSource localDataSource;
  final RemoteAIDataSource? remoteAIDataSource;

  static const int minimumQuestionsForAI = 3;

  QuizRepositoryImpl({required this.localDataSource, this.remoteAIDataSource});

  @override
  Future<Either<Failure, QuizSession>> getQuizSession(int questionCount, {String topic = ''}) async {
    if (topic.isNotEmpty && remoteAIDataSource != null) {
      final aiResult = await remoteAIDataSource!.generateQuestions(questionCount, topic: topic);
      return aiResult.fold((failure) => Left(failure), (aiQuestions) {
        final sessionModel = QuizSessionModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          questionIds: aiQuestions.map((q) => q.id).toList(),
          answers: [],
          startedAt: DateTime.now(),
        );
        final sessionQuestions = aiQuestions.map((q) => q.toEntity()).toList();
        return Right(sessionModel.toEntity(sessionQuestions));
      });
    }

    var questionsResult = await localDataSource.getQuestions();

    return questionsResult.fold((failure) => Left(failure), (questions) async {
      if (questions.length < minimumQuestionsForAI &&
          remoteAIDataSource != null) {
        final aiResult = await remoteAIDataSource!.generateQuestions(5);

        aiResult.fold((failure) {}, (aiQuestions) async {
          await localDataSource.saveQuestions(aiQuestions);
        });

        questionsResult = await localDataSource.getQuestions();
        questions = questionsResult.getOrElse(() => questions);
      }

      return questionsResult.fold((failure) => Left(failure), (questions) {
        if (questions.isEmpty) {
          return const Left(CacheFailure('No questions available'));
        }

        final shuffled = List<QuestionModel>.from(questions)..shuffle();
        final selectedQuestions = shuffled.take(questionCount).toList();

        final sessionModel = QuizSessionModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          questionIds: selectedQuestions.map((q) => q.id).toList(),
          answers: [],
          startedAt: DateTime.now(),
        );

        final sessionQuestions = selectedQuestions
            .map((q) => q.toEntity())
            .toList();
        final session = sessionModel.toEntity(sessionQuestions);

        return Right(session);
      });
    });
  }

  @override
  Future<Either<Failure, List<Question>>> getQuestions() async {
    final result = await localDataSource.getQuestions();
    return result.fold(
      (failure) => Left(failure),
      (models) => Right(models.map((m) => m.toEntity()).toList()),
    );
  }

  @override
  Future<Either<Failure, void>> saveQuestion(Question question) async {
    final model = QuestionModel.fromEntity(question);
    return localDataSource.saveQuestion(model);
  }

  @override
  Future<Either<Failure, void>> saveQuestions(List<Question> questions) async {
    final models = questions.map((q) => QuestionModel.fromEntity(q)).toList();
    return localDataSource.saveQuestions(models);
  }

  Future<Either<Failure, List<Question>>> generateAIQuestions(int count) async {
    if (remoteAIDataSource == null) {
      return const Left(ServerFailure('AI generation not available'));
    }

    final result = await remoteAIDataSource!.generateQuestions(count);

    return result.fold((failure) => Left(failure), (models) async {
      await localDataSource.saveQuestions(models);
      return Right(models.map((m) => m.toEntity()).toList());
    });
  }
}
