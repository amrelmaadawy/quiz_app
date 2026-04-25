import 'package:equatable/equatable.dart';
import '../../domain/entities/question.dart';
import '../../domain/entities/quiz_session.dart';
import '../../domain/entities/result.dart';

abstract class ExamState extends Equatable {
  const ExamState();

  @override
  List<Object?> get props => [];
}

class ExamInitial extends ExamState {
  const ExamInitial();
}

class ExamLoading extends ExamState {
  const ExamLoading();
}

class ExamInProgress extends ExamState {
  final QuizSession session;
  final int currentQuestionIndex;
  final int? selectedIndex;

  const ExamInProgress({
    required this.session,
    required this.currentQuestionIndex,
    this.selectedIndex,
  });

  Question get currentQuestion => session.questions[currentQuestionIndex];
  bool get isLastQuestion =>
      currentQuestionIndex >= session.questions.length - 1;
  int get totalQuestions => session.questions.length;

  ExamInProgress copyWith({
    QuizSession? session,
    int? currentQuestionIndex,
    int? selectedIndex,
  }) {
    return ExamInProgress(
      session: session ?? this.session,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  @override
  List<Object?> get props => [session, currentQuestionIndex, selectedIndex];
}

class ExamCompleted extends ExamState {
  final Result result;

  const ExamCompleted(this.result);

  @override
  List<Object?> get props => [result];
}

class ExamError extends ExamState {
  final String message;

  const ExamError(this.message);

  @override
  List<Object?> get props => [message];
}
