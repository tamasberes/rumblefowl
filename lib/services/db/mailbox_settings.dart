import 'package:hive/hive.dart';
part 'mailbox_settings.g.dart';

@HiveType(typeId: 1)
class MailboxSettings extends HiveObject {
  @HiveField(0, defaultValue: "")
  String userName;
  @HiveField(1, defaultValue: "")
  String password;
  @HiveField(2, defaultValue: "")
  String imapUrl;
  @HiveField(3, defaultValue: 0)
  int imapPort;
  @HiveField(4, defaultValue: true)
  bool useTls;

  @HiveField(5, defaultValue: "email@example.com")
  String emailAddress;

  MailboxSettings(this.userName, this.password, this.imapUrl, this.imapPort, this.useTls, this.emailAddress);
}
