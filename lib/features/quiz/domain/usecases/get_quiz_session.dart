import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/quiz_session.dart';
import '../repositories/quiz_repository.dart';

class GetQuizSessionParams {
  final int questionCount;
  final String topic;
  GetQuizSessionParams({required this.questionCount, this.topic = ''});
}

class GetQuizSessionUseCase
    implements UseCase<QuizSession, GetQuizSessionParams> {
  final QuizRepository repository;

  GetQuizSessionUseCase(this.repository);

  @override
  Future<Either<Failure, QuizSession>> call(GetQuizSessionParams params) {
    return repository.getQuizSession(params.questionCount, topic: params.topic);
  }
}
