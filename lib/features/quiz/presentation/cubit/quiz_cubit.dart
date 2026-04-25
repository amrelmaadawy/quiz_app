import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/enums.dart';
import '../../domain/entities/quiz_session.dart';
import '../../domain/usecases/get_quiz_session.dart';
import '../../domain/usecases/practice_strategy.dart';
import 'quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  final GetQuizSessionUseCase getQuizSession;
  final PracticeStrategy practiceStrategy;

  QuizMode _mode = QuizMode.practice;
  String _topic = '';

  QuizCubit({required this.getQuizSession, required this.practiceStrategy})
    : super(const QuizInitial());

  QuizMode get mode => _mode;
  String get topic => _topic;

  Future<void> startQuiz({
    int questionCount = 5,
    String topic = '',
    QuizMode mode = QuizMode.practice,
  }) async {
    _topic = topic;
    _mode = mode;

    emit(const QuizLoading());

    final result = await getQuizSession(
      GetQuizSessionParams(questionCount: questionCount),
    );

    result.fold(
      (failure) => emit(QuizError(failure.message)),
      (session) => emit(QuizReady(session: session, currentQuestionIndex: 0)),
    );
  }

  void submitAnswer(int selectedIndex) {
    final currentState = state;
    if (currentState is! QuizReady || currentState.answered) return;

    final question = currentState.currentQuestion;
    final answer = practiceStrategy.evaluateAnswer(question, selectedIndex);

    final updatedAnswers = [
      ...currentState.session.answers,
      Answer(
        questionId: question.id,
        selectedIndex: selectedIndex,
        isCorrect: answer.isCorrect,
      ),
    ];

    final updatedSession = currentState.session.copyWith(
      answers: updatedAnswers,
    );

    emit(
      currentState.copyWith(
        session: updatedSession,
        answered: true,
        selectedIndex: selectedIndex,
        isCorrect: answer.isCorrect,
        explanation: answer.explanation,
      ),
    );
  }

  void nextQuestion() {
    final currentState = state;
    if (currentState is! QuizReady) return;

    if (currentState.isLastQuestion) {
      final correctCount = currentState.session.answers
          .where((a) => a.isCorrect)
          .length;

      emit(
        QuizCompleted(
          session: currentState.session,
          correctCount: correctCount,
          totalCount: currentState.totalQuestions,
        ),
      );
    } else {
      emit(
        QuizReady(
          session: currentState.session,
          currentQuestionIndex: currentState.currentQuestionIndex + 1,
        ),
      );
    }
  }

  void resetQuiz() {
    emit(const QuizInitial());
  }
}
