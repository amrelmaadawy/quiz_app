import 'package:flutter/material.dart';
import '../../domain/entities/result.dart';
import '../../../../core/theme/app_colors.dart';
import 'dashboard_page.dart';

class ResultPage extends StatelessWidget {
  final Result result;

  const ResultPage({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final percentage = result.percentage;
    final isPassing = percentage >= 60;
    
    final headerGradient = isPassing ? AppColors.successGradient : AppColors.primaryGradient;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Exam Results', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: headerGradient,
          ),
        ),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSummaryCard(context, percentage, isPassing),
            const SizedBox(height: 32),
            Text(
              'Detailed Breakdown',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 22),
            ),
            const SizedBox(height: 16),
            ...result.questionResults.asMap().entries.map(
              (entry) =>
                  _buildQuestionResultCard(context, entry.key + 1, entry.value),
            ),
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
                  onTap: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const DashboardPage()),
                    (route) => false,
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.home_rounded, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Return to Dashboard', 
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
                        ),
                      ],
                    )
                  )
                )
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    double percentage,
    bool isPassing,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, offset: Offset(0, 8), blurRadius: 24)
        ]
      ),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isPassing ? AppColors.successLight : AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPassing ? Icons.emoji_events_rounded : Icons.psychology_rounded,
                size: 80,
                color: isPassing ? AppColors.success : AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              isPassing ? 'Outstanding!' : 'Keep Learning!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: isPassing ? AppColors.success : AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Here is how you performed in the exam.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatColumn(
                    context,
                    'Score',
                    '${result.correctCount}/${result.totalCount}',
                    AppColors.primary,
                  ),
                  Container(width: 1, height: 40, color: Colors.grey.shade300),
                  _buildStatColumn(context, 'Grade', result.grade, AppColors.textPrimary),
                  Container(width: 1, height: 40, color: Colors.grey.shade300),
                  _buildStatColumn(
                    context,
                    'Pass Rate',
                    '${percentage.toStringAsFixed(0)}%',
                    isPassing ? AppColors.success : AppColors.error,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(BuildContext context, String label, String value, Color valueColor) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildQuestionResultCard(
    BuildContext context,
    int questionNum,
    QuestionResult questionResult,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: questionResult.isCorrect ? AppColors.success.withOpacity(0.3) : AppColors.error.withOpacity(0.3),
        ),
        boxShadow: const [BoxShadow(color: AppColors.cardShadow, offset: Offset(0, 4), blurRadius: 12)]
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: questionResult.isCorrect ? AppColors.successLight.withOpacity(0.5) : AppColors.errorLight.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    questionResult.isCorrect ? Icons.check_rounded : Icons.close_rounded,
                    color: questionResult.isCorrect ? AppColors.success : AppColors.error,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Question $questionNum',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: questionResult.isCorrect ? AppColors.success : AppColors.error,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              questionResult.questionText,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                   if (!questionResult.isCorrect) ...[
                     Row(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         const Icon(Icons.cancel_rounded, size: 18, color: AppColors.error),
                         const SizedBox(width: 8),
                         Expanded(
                           child: Text(
                             'You chose Option ${String.fromCharCode(65 + questionResult.selectedIndex)}',
                             style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.w500),
                           ),
                         ),
                       ],
                     ),
                     const SizedBox(height: 8),
                   ],
                   Row(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Icon(Icons.check_circle_rounded, size: 18, color: AppColors.success),
                       const SizedBox(width: 8),
                       Expanded(
                         child: Text(
                           'Correct Answer: Option ${String.fromCharCode(65 + questionResult.correctIndex)}',
                           style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.bold),
                         ),
                       ),
                     ],
                   ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
