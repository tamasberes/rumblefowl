// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_object.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EmailObjectAdapter extends TypeAdapter<EmailObject> {
  @override
  final int typeId = 2;

  @override
  EmailObject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EmailObject(
      fields[0] == null ? '' : fields[0] as String,
      fields[1] == null ? '' : fields[1] as String,
      fields[2] == null ? '' : fields[2] as String,
      fields[3] == null ? 0 : fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, EmailObject obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.data)
      ..writeByte(1)
      ..write(obj.mailboxId)
      ..writeByte(2)
      ..write(obj.folderName)
      ..writeByte(3)
      ..write(obj.guid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmailObjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
