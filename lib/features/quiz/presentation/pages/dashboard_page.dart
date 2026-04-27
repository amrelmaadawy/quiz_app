import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/enums.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/quiz_cubit.dart';
import '../cubit/quiz_state.dart';
import '../cubit/exam_cubit.dart';
import 'practice_page.dart';
import 'exam_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  QuizMode _selectedMode = QuizMode.practice;

  void _startQuiz(BuildContext context) {
    final topic = 'software design patterns';

    context.read<QuizCubit>().startQuiz(
      topic: topic,
      questionCount: 5,
      mode: _selectedMode,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<QuizCubit, QuizState>(
      listener: (context, state) {
        if (state is QuizReady && ModalRoute.of(context)?.isCurrent == true) {
          if (_selectedMode == QuizMode.practice) {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PracticePage()));
          } else {
            // Start the exam in the ExamCubit since we are entering Exam Mode
            context.read<ExamCubit>().startExam(
              questionCount: 5,
              topic: 'software design patterns',
            );
            Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ExamPage()));
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('AI Quiz Engine', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          backgroundColor: AppColors.primary,
          elevation: 0,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [


                    Text('Quiz Mode', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: AppColors.divider, width: 1.5),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedMode = QuizMode.practice),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: _selectedMode == QuizMode.practice ? AppColors.primary : Colors.transparent,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: _selectedMode == QuizMode.practice ? [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    )
                                  ] : [],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.school_rounded, color: _selectedMode == QuizMode.practice ? Colors.white : AppColors.textSecondary, size: 20),
                                    const SizedBox(width: 8),
                                    Text('Practice', style: TextStyle(
                                      color: _selectedMode == QuizMode.practice ? Colors.white : AppColors.textSecondary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedMode = QuizMode.exam),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: _selectedMode == QuizMode.exam ? AppColors.primary : Colors.transparent,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: _selectedMode == QuizMode.exam ? [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    )
                                  ] : [],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.timer_rounded, color: _selectedMode == QuizMode.exam ? Colors.white : AppColors.textSecondary, size: 20),
                                    const SizedBox(width: 8),
                                    Text('Exam', style: TextStyle(
                                      color: _selectedMode == QuizMode.exam ? Colors.white : AppColors.textSecondary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 48),

                    BlocBuilder<QuizCubit, QuizState>(
                      builder: (context, state) {
                        final isLoading = state is QuizLoading;
                        
                        return Container(
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: _selectedMode == QuizMode.practice ? AppColors.practiceGradient : AppColors.examGradient,
                            boxShadow: [
                              BoxShadow(
                                color: (_selectedMode == QuizMode.practice ? Colors.green : Colors.blue).withOpacity(0.4),
                                offset: const Offset(0, 8),
                                blurRadius: 16,
                              )
                            ]
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: isLoading ? null : () => _startQuiz(context),
                              child: Center(
                                child: isLoading
                                  ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Text('Generate & Start', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                        SizedBox(width: 8),
                                        Icon(Icons.rocket_launch_rounded, color: Colors.white)
                                      ],
                                  )
                              )
                            )
                          ),
                        );
                      },
                    ),
                    
                  ],
                ),
              ),
        ),
      ),
    );
  }
}


