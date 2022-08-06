// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mailbox_folder.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MailboxFolderAdapter extends TypeAdapter<MailboxFolder> {
  @override
  final int typeId = 3;

  @override
  MailboxFolder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MailboxFolder(
      fields[0] == null ? '' : fields[0] as String,
      fields[1] == null ? '' : fields[1] as String,
      fields[2] == null ? '' : fields[2] as String,
      fields[3] == null ? 0 : fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, MailboxFolder obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.emailAddress)
      ..writeByte(1)
      ..write(obj.folderName)
      ..writeByte(2)
      ..write(obj.mailboxFlags)
      ..writeByte(3)
      ..write(obj.messagecount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MailboxFolderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
