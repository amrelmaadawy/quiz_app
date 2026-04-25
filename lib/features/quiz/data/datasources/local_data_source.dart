import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../models/question_model.dart';
import '../models/quiz_session_model.dart';

abstract class LocalDataSource {
  Future<Either<Failure, List<QuestionModel>>> getQuestions();
  Future<Either<Failure, QuizSessionModel>> getQuizSession(int questionCount);
  Future<Either<Failure, void>> saveQuestion(QuestionModel question);
  Future<Either<Failure, void>> saveQuestions(List<QuestionModel> questions);
  Future<Either<Failure, void>> saveQuizSession(QuizSessionModel session);
  List<QuestionModel> getFallbackQuestions();
}
