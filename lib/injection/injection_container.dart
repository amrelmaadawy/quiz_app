import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import '../../features/quiz/data/datasources/local_data_source.dart';
import '../../features/quiz/data/datasources/local_data_source_impl.dart';
import '../../features/quiz/data/datasources/remote_ai_data_source.dart';
import '../../features/quiz/data/models/question_model.dart';
import '../../features/quiz/data/models/quiz_session_model.dart';
import '../../features/quiz/data/repositories/quiz_repository_impl.dart';
import '../../features/quiz/domain/repositories/quiz_repository.dart';
import '../../features/quiz/domain/usecases/get_quiz_session.dart';
import '../../features/quiz/domain/usecases/practice_strategy.dart';
import '../../features/quiz/domain/usecases/exam_strategy.dart';
import '../../features/quiz/domain/usecases/submit_quiz.dart';
import '../../features/quiz/presentation/cubit/quiz_cubit.dart';
import '../../features/quiz/presentation/cubit/exam_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => http.Client());

  // Cubits
  sl.registerFactory(
    () => QuizCubit(getQuizSession: sl(), practiceStrategy: sl()),
  );

  sl.registerFactory(() => ExamCubit(getQuizSession: sl(), submitQuiz: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetQuizSessionUseCase(sl()));
  sl.registerLazySingleton(() => SubmitQuizUseCase());

  // Strategies
  sl.registerLazySingleton<PracticeStrategy>(() => PracticeStrategy());
  sl.registerLazySingleton<ExamStrategy>(() => ExamStrategy());

  // Data sources
  sl.registerLazySingleton<LocalDataSource>(
    () => LocalDataSourceImpl(
      questionBox: sl<Box<QuestionModel>>(),
      sessionBox: sl<Box<QuizSessionModel>>(),
    ),
  );

  sl.registerLazySingleton<RemoteAIDataSource>(() => MockAIDataSourceImpl());

  // Repository
  sl.registerLazySingleton<QuizRepository>(
    () => QuizRepositoryImpl(localDataSource: sl(), remoteAIDataSource: sl()),
  );

  // External
  sl.registerLazySingleton<Box<QuestionModel>>(
    () => Hive.box<QuestionModel>('questions'),
  );
  sl.registerLazySingleton<Box<QuizSessionModel>>(
    () => Hive.box<QuizSessionModel>('sessions'),
  );
}

Future<void> seedQuestions() async {
  final questionBox = Hive.box<QuestionModel>('questions');

  if (questionBox.isEmpty) {
    final sampleQuestions = [
      QuestionModel(
        id: '1',
        text: 'What is the Singleton design pattern used for?',
        options: [
          'Ensures a class has only one instance',
          'Creates objects without specifying exact class',
          'Provides a way to access elements sequentially',
          'Defines a family of algorithms',
        ],
        correctIndex: 0,
        explanation:
            'The Singleton pattern ensures that a class has only one instance and provides a global point of access to it.',
      ),
      QuestionModel(
        id: '2',
        text: 'Which pattern defines a family of interchangeable algorithms?',
        options: ['Observer', 'Strategy', 'Decorator', 'Factory'],
        correctIndex: 1,
        explanation:
            'The Strategy pattern defines a family of algorithms, encapsulates each one, and makes them interchangeable.',
      ),
      QuestionModel(
        id: '3',
        text: 'What does the Factory pattern do?',
        options: [
          'Creates objects without specifying exact class',
          'Ensures only one instance exists',
          'Adds behavior dynamically',
          'Defines one-to-many dependency',
        ],
        correctIndex: 0,
        explanation:
            'The Factory pattern provides an interface for creating objects without specifying their exact classes.',
      ),
      QuestionModel(
        id: '4',
        text:
            'In which pattern is there a one-to-many dependency between objects?',
        options: ['Singleton', 'Observer', 'Decorator', 'Adapter'],
        correctIndex: 1,
        explanation:
            'The Observer pattern defines a one-to-many dependency between objects so when one changes state, all dependents are notified.',
      ),
      QuestionModel(
        id: '5',
        text: 'What is the purpose of the Decorator pattern?',
        options: [
          'Ensure single instance',
          'Add behavior dynamically to objects',
          'Convert interface of a class to another',
          'Separate algorithm from object',
        ],
        correctIndex: 1,
        explanation:
            'The Decorator pattern attaches additional responsibilities to an object dynamically, providing a flexible alternative to subclassing.',
      ),
    ];

    for (final q in sampleQuestions) {
      await questionBox.put(q.id, q);
    }
  }
}
