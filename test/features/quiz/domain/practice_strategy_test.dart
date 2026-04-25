import 'package:flutter_test/flutter_test.dart';
import 'package:quiz1/features/quiz/domain/entities/question.dart';
import 'package:quiz1/features/quiz/domain/usecases/practice_strategy.dart';

void main() {
  late PracticeStrategy strategy;

  setUp(() {
    strategy = PracticeStrategy();
  });

  group('PracticeStrategy', () {
    test(
      'should return correct answer when selected index matches correct index',
      () {
        const question = Question(
          id: '1',
          text: 'What is Singleton?',
          options: [
            'One instance',
            'Two instances',
            'Three instances',
            'Four instances',
          ],
          correctIndex: 0,
          explanation: 'Singleton ensures one instance',
        );

        final answer = strategy.evaluateAnswer(question, 0);

        expect(answer.isCorrect, true);
        expect(answer.explanation, question.explanation);
      },
    );

    test(
      'should return incorrect answer when selected index does not match',
      () {
        const question = Question(
          id: '1',
          text: 'What is Singleton?',
          options: [
            'One instance',
            'Two instances',
            'Three instances',
            'Four instances',
          ],
          correctIndex: 0,
          explanation: 'Singleton ensures one instance',
        );

        final answer = strategy.evaluateAnswer(question, 1);

        expect(answer.isCorrect, false);
        expect(answer.explanation, question.explanation);
      },
    );

    test('should always show immediate feedback', () {
      expect(strategy.showImmediateFeedback, true);
    });

    test('should always show explanations', () {
      expect(strategy.showExplanations, true);
    });

    test('should evaluate all incorrect indices correctly', () {
      const question = Question(
        id: '1',
        text: 'Test question',
        options: ['A', 'B', 'C', 'D'],
        correctIndex: 2,
        explanation: 'C is correct',
      );

      expect(strategy.evaluateAnswer(question, 0).isCorrect, false);
      expect(strategy.evaluateAnswer(question, 1).isCorrect, false);
      expect(strategy.evaluateAnswer(question, 2).isCorrect, true);
      expect(strategy.evaluateAnswer(question, 3).isCorrect, false);
    });
  });
}
