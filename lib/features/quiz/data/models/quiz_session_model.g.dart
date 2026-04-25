// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_session_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AnswerModelAdapter extends TypeAdapter<AnswerModel> {
  @override
  final int typeId = 1;

  @override
  AnswerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AnswerModel(
      questionId: fields[0] as String,
      selectedIndex: fields[1] as int,
      isCorrect: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AnswerModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.questionId)
      ..writeByte(1)
      ..write(obj.selectedIndex)
      ..writeByte(2)
      ..write(obj.isCorrect);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnswerModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QuizSessionModelAdapter extends TypeAdapter<QuizSessionModel> {
  @override
  final int typeId = 2;

  @override
  QuizSessionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuizSessionModel(
      id: fields[0] as String,
      questionIds: (fields[1] as List).cast<String>(),
      answers: (fields[2] as List).cast<AnswerModel>(),
      startedAt: fields[3] as DateTime,
      completedAt: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, QuizSessionModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.questionIds)
      ..writeByte(2)
      ..write(obj.answers)
      ..writeByte(3)
      ..write(obj.startedAt)
      ..writeByte(4)
      ..write(obj.completedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuizSessionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
