import 'package:equatable/equatable.dart';
import '../../domain/entities/question.dart';
import '../../domain/entities/quiz_session.dart';

abstract class QuizState extends Equatable {
  const QuizState();

  @override
  List<Object?> get props => [];
}

class QuizInitial extends QuizState {
  const QuizInitial();
}

class QuizLoading extends QuizState {
  const QuizLoading();
}

class QuizReady extends QuizState {
  final QuizSession session;
  final int currentQuestionIndex;
  final bool answered;
  final int? selectedIndex;
  final bool? isCorrect;
  final String? explanation;

  const QuizReady({
    required this.session,
    required this.currentQuestionIndex,
    this.answered = false,
    this.selectedIndex,
    this.isCorrect,
    this.explanation,
  });

  Question get currentQuestion => session.questions[currentQuestionIndex];
  bool get isLastQuestion =>
      currentQuestionIndex >= session.questions.length - 1;
  int get totalQuestions => session.questions.length;
  int get answeredCount => session.answers.length;

  QuizReady copyWith({
    QuizSession? session,
    int? currentQuestionIndex,
    bool? answered,
    int? selectedIndex,
    bool? isCorrect,
    String? explanation,
  }) {
    return QuizReady(
      session: session ?? this.session,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      answered: answered ?? this.answered,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isCorrect: isCorrect ?? this.isCorrect,
      explanation: explanation ?? this.explanation,
    );
  }

  @override
  List<Object?> get props => [
    session,
    currentQuestionIndex,
    answered,
    selectedIndex,
    isCorrect,
    explanation,
  ];
}

class QuizCompleted extends QuizState {
  final QuizSession session;
  final int correctCount;
  final int totalCount;

  const QuizCompleted({
    required this.session,
    required this.correctCount,
    required this.totalCount,
  });

  double get percentage =>
      totalCount > 0 ? (correctCount / totalCount) * 100 : 0;

  @override
  List<Object?> get props => [session, correctCount, totalCount];
}

class QuizError extends QuizState {
  final String message;

  const QuizError(this.message);

  @override
  List<Object?> get props => [message];
}
