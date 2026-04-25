import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/quiz_session.dart';
import '../entities/result.dart';

class SubmitQuizUseCase implements UseCase<Result, QuizSession> {
  @override
  Future<Either<Failure, Result>> call(QuizSession session) async {
    if (session.answers.isEmpty) {
      return const Left(ValidationFailure('No answers submitted'));
    }

    final questionResults = <QuestionResult>[];
    int correctCount = 0;

    for (int i = 0; i < session.questions.length; i++) {
      final question = session.questions[i];
      final answer = session.answers.length > i ? session.answers[i] : null;

      if (answer == null) continue;

      final isCorrect = answer.isCorrect;
      if (isCorrect) correctCount++;

      questionResults.add(
        QuestionResult(
          questionId: question.id,
          questionText: question.text,
          selectedIndex: answer.selectedIndex,
          correctIndex: question.correctIndex,
          isCorrect: isCorrect,
        ),
      );
    }

    final result = Result(
      sessionId: session.id,
      correctCount: correctCount,
      totalCount: session.questions.length,
      questionResults: questionResults,
      completedAt: DateTime.now(),
    );

    return Right(result);
  }
}
