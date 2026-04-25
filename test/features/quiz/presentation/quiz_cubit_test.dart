import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiz1/core/errors/failures.dart';
import 'package:quiz1/features/quiz/domain/entities/question.dart';
import 'package:quiz1/features/quiz/domain/entities/quiz_session.dart';
import 'package:quiz1/features/quiz/domain/usecases/get_quiz_session.dart';
import 'package:quiz1/features/quiz/domain/usecases/practice_strategy.dart';
import 'package:quiz1/features/quiz/presentation/cubit/quiz_cubit.dart';
import 'package:quiz1/features/quiz/presentation/cubit/quiz_state.dart';

class MockGetQuizSessionUseCase extends Mock implements GetQuizSessionUseCase {}

class MockPracticeStrategy extends Mock implements PracticeStrategy {}

void main() {
  late QuizCubit quizCubit;
  late MockGetQuizSessionUseCase mockGetQuizSession;
  late MockPracticeStrategy mockPracticeStrategy;

  final testQuestion = Question(
    id: '1',
    text: 'What is Singleton?',
    options: const [
      'One instance',
      'Two instances',
      'Three instances',
      'Four instances',
    ],
    correctIndex: 0,
    explanation: 'Singleton ensures one instance',
  );

  final testSession = QuizSession(
    id: 'session_1',
    questions: [testQuestion],
    answers: const [],
    startedAt: DateTime(2024, 1, 1),
  );

  setUpAll(() {
    registerFallbackValue(GetQuizSessionParams(questionCount: 1));
  });

  setUp(() {
    mockGetQuizSession = MockGetQuizSessionUseCase();
    mockPracticeStrategy = MockPracticeStrategy();
    quizCubit = QuizCubit(
      getQuizSession: mockGetQuizSession,
      practiceStrategy: mockPracticeStrategy,
    );
  });

  tearDown(() {
    quizCubit.close();
  });

  group('QuizCubit', () {
    test('initial state should be QuizInitial', () {
      expect(quizCubit.state, const QuizInitial());
    });

    group('startQuiz', () {
      blocTest<QuizCubit, QuizState>(
        'emits [QuizLoading, QuizReady] when startQuiz succeeds',
        build: () {
          when(
            () => mockGetQuizSession(any()),
          ).thenAnswer((_) async => Right(testSession));
          return quizCubit;
        },
        act: (cubit) => cubit.startQuiz(questionCount: 1),
        expect: () => [
          const QuizLoading(),
          isA<QuizReady>()
              .having((s) => s.session.id, 'session.id', 'session_1')
              .having((s) => s.currentQuestionIndex, 'currentQuestionIndex', 0),
        ],
      );

      blocTest<QuizCubit, QuizState>(
        'emits [QuizLoading, QuizError] when startQuiz fails',
        build: () {
          when(
            () => mockGetQuizSession(any()),
          ).thenAnswer((_) async => const Left(CacheFailure('No questions')));
          return quizCubit;
        },
        act: (cubit) => cubit.startQuiz(questionCount: 1),
        expect: () => [const QuizLoading(), const QuizError('No questions')],
      );
    });

    group('resetQuiz', () {
      blocTest<QuizCubit, QuizState>(
        'emits QuizInitial when resetQuiz is called',
        build: () => quizCubit,
        seed: () => const QuizError('Some error'),
        act: (cubit) => cubit.resetQuiz(),
        expect: () => [const QuizInitial()],
      );
    });
  });
}
