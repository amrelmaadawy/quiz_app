import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/quiz_cubit.dart';
import '../cubit/quiz_state.dart';
import 'dashboard_page.dart';

class PracticePage extends StatelessWidget {
  const PracticePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Practice Mode'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.practiceGradient,
          ),
        ),
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<QuizCubit, QuizState>(
        builder: (context, state) {
          if (state is QuizLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (state is QuizError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(color: AppColors.error, fontSize: 18),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.read<QuizCubit>().startQuiz(),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          if (state is QuizReady) {
            return _buildQuestionView(context, state);
          }

          if (state is QuizCompleted) {
            return _buildResultView(context, state);
          }

          return const Center(
            child: Text('Press Start to begin your practice session'),
          );
        },
      ),
    );
  }

  Widget _buildQuestionView(BuildContext context, QuizReady state) {
    final question = state.currentQuestion;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${state.currentQuestionIndex + 1}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.primary),
              ),
              Text(
                'of ${state.totalQuestions}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (state.currentQuestionIndex + 1) / state.totalQuestions,
              minHeight: 8,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(height: 32),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(color: AppColors.cardShadow, offset: Offset(0, 8), blurRadius: 24)
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Text(
              question.text,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 22, height: 1.4
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          ...List.generate(
            question.options.length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildOptionButton(context, state, index),
            ),
          ),
          if (state.answered) ...[
            const SizedBox(height: 16),
            _buildFeedbackCard(state),
            const SizedBox(height: 32),
            Container(
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: AppColors.primaryGradient,
                boxShadow: [
                  BoxShadow(color: AppColors.primary.withOpacity(0.4), offset: const Offset(0, 8), blurRadius: 16)
                ]
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => context.read<QuizCubit>().nextQuestion(),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.isLastQuestion ? 'See Results' : 'Next Question', 
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, color: Colors.white)
                      ],
                    )
                  )
                )
              ),
            ),
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context, QuizReady state, int index) {
    final question = state.currentQuestion;
    final isSelected = state.selectedIndex == index;
    final isCorrectAnswer = index == question.correctIndex;

    Color backgroundColor = AppColors.surface;
    Color borderColor = AppColors.surface;
    Color textColor = AppColors.textPrimary;
    IconData? trailingIcon;
    Color? iconColor;

    if (state.answered) {
      if (isCorrectAnswer) {
        backgroundColor = AppColors.successLight;
        borderColor = AppColors.success;
        textColor = AppColors.success;
        trailingIcon = Icons.check_circle_rounded;
        iconColor = AppColors.success;
      } else if (isSelected && !isCorrectAnswer) {
        backgroundColor = AppColors.errorLight;
        borderColor = AppColors.error;
        textColor = AppColors.error;
        trailingIcon = Icons.cancel_rounded;
        iconColor = AppColors.error;
      }
    } else if (isSelected) {
      backgroundColor = AppColors.primary.withOpacity(0.1);
      borderColor = AppColors.primary;
      textColor = AppColors.primary;
    }

    return GestureDetector(
      onTap: state.answered ? null : () => context.read<QuizCubit>().submitAnswer(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: state.answered && (isCorrectAnswer || isSelected) ? borderColor : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            if (!state.answered) 
              const BoxShadow(color: AppColors.cardShadow, offset: Offset(0, 4), blurRadius: 12)
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: state.answered && (isCorrectAnswer || isSelected) ? backgroundColor : AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  String.fromCharCode(65 + index),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: state.answered && (isCorrectAnswer || isSelected) ? textColor : AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                question.options[index],
                style: TextStyle(fontSize: 16, color: textColor, fontWeight: FontWeight.w500),
              ),
            ),
            if (trailingIcon != null) ...[
              const SizedBox(width: 12),
              Icon(trailingIcon, color: iconColor),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackCard(QuizReady state) {
    final isCorrect = state.isCorrect ?? false;

    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 500),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isCorrect ? AppColors.successLight.withOpacity(0.5) : AppColors.errorLight.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCorrect ? AppColors.success.withOpacity(0.3) : AppColors.error.withOpacity(0.3),
            width: 1,
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isCorrect ? Icons.auto_awesome : Icons.lightbulb_outline,
                  color: isCorrect ? AppColors.success : AppColors.errorDark,
                ),
                const SizedBox(width: 12),
                Text(
                  isCorrect ? 'Excellent!' : 'Explanation',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isCorrect ? AppColors.success : AppColors.errorDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              state.explanation ?? '', 
              style: TextStyle(fontSize: 15, color: isCorrect ? Colors.green[800] : Colors.red[800], height: 1.5)
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultView(BuildContext context, QuizCompleted state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.workspace_premium_rounded, size: 100, color: Colors.amber),
            const SizedBox(height: 24),
            Text(
              'Practice Complete',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [BoxShadow(color: AppColors.cardShadow, offset: Offset(0, 8), blurRadius: 24)]
              ),
              child: Column(
                children: [
                  Text(
                    '${state.correctCount} / ${state.totalCount}',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(color: AppColors.primary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Correct Answers',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () => context.read<QuizCubit>().startQuiz(),
                child: const Text('Practice Again', style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const DashboardPage()),
                (route) => false,
              ),
              child: const Text('Return to Dashboard', style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
            )
          ],
        ),
      ),
    );
  }
}
