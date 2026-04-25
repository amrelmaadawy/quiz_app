import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/exam_cubit.dart';
import '../cubit/exam_state.dart';
import 'result_page.dart';

class ExamPage extends StatelessWidget {
  const ExamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Exam Mode', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.examGradient,
          ),
        ),
        foregroundColor: Colors.white,
        actions: [
          BlocBuilder<ExamCubit, ExamState>(
            builder: (context, state) {
              if (state is ExamInProgress) {
                return Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${state.currentQuestionIndex + 1} / ${state.totalQuestions}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocConsumer<ExamCubit, ExamState>(
        listener: (context, state) {
          if (state is ExamCompleted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => ResultPage(result: state.result),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ExamLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (state is ExamError) {
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
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<ExamCubit>().startExam(),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          if (state is ExamInProgress) {
            return _buildQuestionView(context, state);
          }

          return const Center(child: Text('Press Start to begin your exam'));
        },
      ),
    );
  }

  Widget _buildQuestionView(BuildContext context, ExamInProgress state) {
    final question = state.currentQuestion;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (state.currentQuestionIndex + 1) / state.totalQuestions,
              minHeight: 8,
              backgroundColor: const Color(0xFF2196F3).withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2196F3)),
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
          const SizedBox(height: 32),
          Container(
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: state.selectedIndex != null ? AppColors.examGradient : null,
              color: state.selectedIndex == null ? Colors.grey[300] : null,
              boxShadow: state.selectedIndex != null ? [
                BoxShadow(color: const Color(0xFF2196F3).withOpacity(0.4), offset: const Offset(0, 8), blurRadius: 16)
              ] : [],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: state.selectedIndex != null
                    ? () => context.read<ExamCubit>().nextQuestion()
                    : null,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.currentQuestionIndex == state.totalQuestions - 1 ? 'Submit Exam' : 'Next Question', 
                        style: TextStyle(color: state.selectedIndex != null ? Colors.white : Colors.grey[600], fontSize: 18, fontWeight: FontWeight.bold)
                      ),
                      const SizedBox(width: 8),
                      Icon(state.currentQuestionIndex == state.totalQuestions - 1 ? Icons.check_circle_rounded : Icons.arrow_forward_rounded, 
                           color: state.selectedIndex != null ? Colors.white : Colors.grey[600])
                    ],
                  )
                )
              )
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildOptionButton(
    BuildContext context,
    ExamInProgress state,
    int index,
  ) {
    final isSelected = state.selectedIndex == index;
    final primaryColor = const Color(0xFF2196F3);

    return GestureDetector(
      onTap: () => context.read<ExamCubit>().selectAnswer(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.08) : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            if (!isSelected) 
              const BoxShadow(color: AppColors.cardShadow, offset: Offset(0, 4), blurRadius: 12)
          ],
        ),
        child: Row(
          children: [
             AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? primaryColor : Colors.grey.shade300,
                    width: 2,
                  ),
                  color: isSelected ? primaryColor : Colors.transparent,
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                state.currentQuestion.options[index],
                style: TextStyle(
                  fontSize: 16, 
                  color: isSelected ? primaryColor : AppColors.textPrimary, 
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
