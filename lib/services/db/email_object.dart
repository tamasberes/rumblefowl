import 'package:hive/hive.dart';

part 'email_object.g.dart';

@HiveType(typeId: 2)
class EmailObject extends HiveObject {
  @HiveField(0, defaultValue: "")
  String data;
  @HiveField(1, defaultValue: "")
  String mailboxId;
  @HiveField(2, defaultValue: "")
  String folderName;
  @HiveField(3, defaultValue: 0)
  int guid;

  EmailObject(this.data, this.mailboxId, this.folderName, this.guid);
}
