import 'package:hive/hive.dart';

part 'mailbox_folder.g.dart';

@HiveType(typeId: 3)
class MailboxFolder extends HiveObject {
  @HiveField(0, defaultValue: "")
  String emailAddress;
  @HiveField(1, defaultValue: "")
  String folderName;
  @HiveField(2, defaultValue: "")
  String mailboxFlags;
  @HiveField(3, defaultValue: 0)
  int messagecount;
  
  MailboxFolder(this.emailAddress, this.folderName, this.mailboxFlags, this.messagecount);
}
