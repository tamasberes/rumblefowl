// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mailbox_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MailboxSettingsAdapter extends TypeAdapter<MailboxSettings> {
  @override
  final int typeId = 1;

  @override
  MailboxSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MailboxSettings(
      fields[0] == null ? '' : fields[0] as String,
      fields[1] == null ? '' : fields[1] as String,
      fields[2] == null ? '' : fields[2] as String,
      fields[3] == null ? 0 : fields[3] as int,
      fields[4] == null ? true : fields[4] as bool,
      fields[5] == null ? 'email@example.com' : fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MailboxSettings obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.userName)
      ..writeByte(1)
      ..write(obj.password)
      ..writeByte(2)
      ..write(obj.imapUrl)
      ..writeByte(3)
      ..write(obj.imapPort)
      ..writeByte(4)
      ..write(obj.useTls)
      ..writeByte(5)
      ..write(obj.emailAddress);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MailboxSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
