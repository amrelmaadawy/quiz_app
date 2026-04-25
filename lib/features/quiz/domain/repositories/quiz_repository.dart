import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/question.dart';
import '../entities/quiz_session.dart';

abstract class QuizRepository {
  Future<Either<Failure, QuizSession>> getQuizSession(int questionCount);
  Future<Either<Failure, List<Question>>> getQuestions();
  Future<Either<Failure, void>> saveQuestion(Question question);
  Future<Either<Failure, void>> saveQuestions(List<Question> questions);
}
