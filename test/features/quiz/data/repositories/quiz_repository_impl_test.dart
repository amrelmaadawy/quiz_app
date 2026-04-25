import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quiz1/core/errors/failures.dart';
import 'package:quiz1/features/quiz/data/datasources/local_data_source.dart';
import 'package:quiz1/features/quiz/data/datasources/remote_ai_data_source.dart';
import 'package:quiz1/features/quiz/data/models/question_model.dart';
import 'package:quiz1/features/quiz/data/models/quiz_session_model.dart';
import 'package:quiz1/features/quiz/data/repositories/quiz_repository_impl.dart';

class MockLocalDataSource extends Mock implements LocalDataSource {}

class MockRemoteAIDataSource extends Mock implements RemoteAIDataSource {}

void main() {
  late QuizRepositoryImpl repository;
  late MockLocalDataSource mockLocalDataSource;
  late MockRemoteAIDataSource mockRemoteAIDataSource;

  setUpAll(() {
    registerFallbackValue(<QuestionModel>[]);
    registerFallbackValue(1);
  });

  setUp(() {
    mockLocalDataSource = MockLocalDataSource();
    mockRemoteAIDataSource = MockRemoteAIDataSource();
    repository = QuizRepositoryImpl(
      localDataSource: mockLocalDataSource,
      remoteAIDataSource: mockRemoteAIDataSource,
    );

    when(
      () => mockRemoteAIDataSource.generateQuestions(any()),
    ).thenAnswer((_) async => const Right([]));
    when(
      () => mockLocalDataSource.saveQuestions(any()),
    ).thenAnswer((_) async => const Right(null));
  });

  group('QuizRepositoryImpl', () {
    group('getQuestions', () {
      test('should return Right(Questions) on success', () async {
        final questionModels = [
          QuestionModel(
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
          ),
        ];

        when(
          () => mockLocalDataSource.getQuestions(),
        ).thenAnswer((_) async => Right(questionModels));

        final result = await repository.getQuestions();

        expect(result.isRight(), true);
        verify(() => mockLocalDataSource.getQuestions()).called(1);
      });

      test('should return Left(CacheFailure) on exception', () async {
        when(
          () => mockLocalDataSource.getQuestions(),
        ).thenAnswer((_) async => const Left(CacheFailure('Cache error')));

        final result = await repository.getQuestions();

        expect(result.isLeft(), true);
      });
    });

    group('getQuizSession', () {
      test(
        'should return Right(QuizSession) when questions available',
        () async {
          final questionModels = [
            QuestionModel(
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
            ),
          ];

          final sessionModel = QuizSessionModel(
            id: 'session_1',
            questionIds: const ['1'],
            answers: const [],
            startedAt: DateTime(2024, 1, 1),
          );

          when(
            () => mockLocalDataSource.getQuizSession(any()),
          ).thenAnswer((_) async => Right(sessionModel));
          when(
            () => mockLocalDataSource.getQuestions(),
          ).thenAnswer((_) async => Right(questionModels));

          final result = await repository.getQuizSession(1);

          expect(result.isRight(), true);
        },
      );
    });

    group('saveQuestions', () {
      test('should save questions to local data source', () async {
        final questions = [
          QuestionModel(
            id: '1',
            text: 'Test question',
            options: const ['A', 'B', 'C', 'D'],
            correctIndex: 0,
            explanation: 'Test explanation',
          ),
        ];

        when(
          () => mockLocalDataSource.saveQuestions(any()),
        ).thenAnswer((_) async => const Right(null));

        final result = await repository.saveQuestions(
          questions.map((m) => m.toEntity()).toList(),
        );

        expect(result.isRight(), true);
        verify(() => mockLocalDataSource.saveQuestions(any())).called(1);
      });
    });
  });
}
