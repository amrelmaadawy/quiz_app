enum QuizMode { practice, exam, random }

extension QuizModeExtension on QuizMode {
  String get displayName {
    switch (this) {
      case QuizMode.practice:
        return 'Practice';
      case QuizMode.exam:
        return 'Exam';
      case QuizMode.random:
        return 'Random';
    }
  }
}
