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
  final _topicController = TextEditingController();
  int _questionCount = 5;
  QuizMode _selectedMode = QuizMode.practice;

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  void _startQuiz(BuildContext context) {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();
    
    final topic = _topicController.text.trim().isEmpty
        ? 'design patterns'
        : _topicController.text.trim();

    context.read<QuizCubit>().startQuiz(
      topic: topic,
      questionCount: _questionCount,
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
              questionCount: _questionCount,
            );
            Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ExamPage()));
          }
        }
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 220,
              pinned: true,
              backgroundColor: AppColors.primary,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -50,
                        top: -50,
                        child: Icon(
                          Icons.psychology,
                          size: 200,
                          color: Colors.white.withOpacity(0.15),
                        ),
                      ),
                      Positioned(
                        left: 24,
                        bottom: 40,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text('AI QUIZ ENGINE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Test Your\nKnowledge.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Quiz Configuration',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _topicController,
                      decoration: const InputDecoration(
                        labelText: 'What do you want to learn?',
                        hintText: 'e.g., flutter state management',
                        prefixIcon: Icon(Icons.search, color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Number of Questions: ', style: Theme.of(context).textTheme.titleMedium),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                           decoration: BoxDecoration(
                             color: AppColors.primary.withOpacity(0.1),
                             borderRadius: BorderRadius.circular(16)
                           ),
                           child: Text(
                            '$_questionCount',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: AppColors.primary,
                        inactiveTrackColor: AppColors.primary.withOpacity(0.2),
                        thumbColor: AppColors.primaryDark,
                        overlayColor: AppColors.primary.withOpacity(0.1),
                      ),
                      child: Slider(
                        value: _questionCount.toDouble(),
                        min: 3,
                        max: 10,
                        divisions: 7,
                        onChanged: (value) {
                          setState(() { _questionCount = value.round(); });
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    Text('Quiz Mode', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _ModeSelectorButton(
                            title: 'Practice',
                            icon: Icons.school_rounded,
                            isSelected: _selectedMode == QuizMode.practice,
                            gradient: AppColors.practiceGradient,
                            onTap: () => setState(() => _selectedMode = QuizMode.practice),
                          )
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _ModeSelectorButton(
                            title: 'Exam',
                            icon: Icons.timer_rounded,
                            isSelected: _selectedMode == QuizMode.exam,
                            gradient: AppColors.examGradient,
                            onTap: () => setState(() => _selectedMode = QuizMode.exam),
                          )
                        ),
                      ]
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
          ],
        ),
      ),
    );
  }
}

class _ModeSelectorButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _ModeSelectorButton({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isSelected ? null : AppColors.surface,
          gradient: isSelected ? gradient : null,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppColors.cardShadow,
            width: 2,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: gradient.colors.first.withOpacity(0.3),
              offset: const Offset(0, 4),
              blurRadius: 12,
            )
          ] : [],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
