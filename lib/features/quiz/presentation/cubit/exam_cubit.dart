import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/quiz_session.dart';
import '../../domain/usecases/get_quiz_session.dart';
import '../../domain/usecases/submit_quiz.dart';
import 'exam_state.dart';

class ExamCubit extends Cubit<ExamState> {
  final GetQuizSessionUseCase getQuizSession;
  final SubmitQuizUseCase submitQuiz;

  ExamCubit({required this.getQuizSession, required this.submitQuiz})
    : super(const ExamInitial());

  Future<void> startExam({int questionCount = 5, String topic = ''}) async {
    emit(const ExamLoading());

    final result = await getQuizSession(
      GetQuizSessionParams(questionCount: questionCount, topic: topic),
    );

    result.fold(
      (failure) => emit(ExamError(failure.message)),
      (session) =>
          emit(ExamInProgress(session: session, currentQuestionIndex: 0)),
    );
  }

  void selectAnswer(int index) {
    final currentState = state;
    if (currentState is! ExamInProgress) return;

    emit(currentState.copyWith(selectedIndex: index));
  }

  Future<void> nextQuestion() async {
    final currentState = state;
    if (currentState is! ExamInProgress) return;

    final selectedIndex = currentState.selectedIndex;
    if (selectedIndex == null) return;

    final question = currentState.currentQuestion;
    final isCorrect = selectedIndex == question.correctIndex;

    final updatedAnswers = [
      ...currentState.session.answers,
      Answer(
        questionId: question.id,
        selectedIndex: selectedIndex,
        isCorrect: isCorrect,
      ),
    ];

    final updatedSession = currentState.session.copyWith(
      answers: updatedAnswers,
    );

    if (currentState.isLastQuestion) {
      final resultResult = await submitQuiz(updatedSession);

      resultResult.fold(
        (failure) => emit(ExamError(failure.message)),
        (result) => emit(ExamCompleted(result)),
      );
    } else {
      emit(
        ExamInProgress(
          session: updatedSession,
          currentQuestionIndex: currentState.currentQuestionIndex + 1,
        ),
      );
    }
  }

  void resetExam() {
    emit(const ExamInitial());
  }
}
