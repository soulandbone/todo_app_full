// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class TodoAdapter extends TypeAdapter<Todo> {
  @override
  final int typeId = 0;

  @override
  Todo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Todo(
      creationDate: fields[6] as DateTime,
      title: fields[0] as String,
      isCompleted: fields[1] as bool,
      frequency: fields[2] as Frequency,
      specificDays: (fields[3] as List?)?.cast<bool>(),
      specificDate: fields[4] as DateTime?,
      firstDueDate: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Todo obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.isCompleted)
      ..writeByte(2)
      ..write(obj.frequency)
      ..writeByte(3)
      ..write(obj.specificDays)
      ..writeByte(4)
      ..write(obj.specificDate)
      ..writeByte(6)
      ..write(obj.creationDate)
      ..writeByte(7)
      ..write(obj.firstDueDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FrequencyAdapter extends TypeAdapter<Frequency> {
  @override
  final int typeId = 1;

  @override
  Frequency read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Frequency.daily;
      case 1:
        return Frequency.weekly;
      case 2:
        return Frequency.specific;
      default:
        return Frequency.daily;
    }
  }

  @override
  void write(BinaryWriter writer, Frequency obj) {
    switch (obj) {
      case Frequency.daily:
        writer.writeByte(0);
      case Frequency.weekly:
        writer.writeByte(1);
      case Frequency.specific:
        writer.writeByte(2);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FrequencyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
