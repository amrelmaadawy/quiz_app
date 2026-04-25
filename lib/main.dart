import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/quiz/data/models/question_model.dart';
import 'features/quiz/data/models/quiz_session_model.dart';
import 'features/quiz/presentation/cubit/quiz_cubit.dart';
import 'features/quiz/presentation/cubit/exam_cubit.dart';
import 'features/quiz/presentation/pages/dashboard_page.dart';
import 'injection/injection_container.dart' as di;

import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(QuestionModelAdapter());
  Hive.registerAdapter(AnswerModelAdapter());
  Hive.registerAdapter(QuizSessionModelAdapter());

  await Hive.openBox<QuestionModel>('questions');
  await Hive.openBox<QuizSessionModel>('sessions');

  await di.init();
  await di.seedQuestions();

  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<QuizCubit>(create: (_) => di.sl<QuizCubit>()),
        BlocProvider<ExamCubit>(create: (_) => di.sl<ExamCubit>()),
      ],
      child: MaterialApp(
        title: 'Quiz App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const DashboardPage(),
      ),
    );
  }
}
