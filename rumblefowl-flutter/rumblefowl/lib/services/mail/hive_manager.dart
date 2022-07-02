import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rumblefowl/services/mail/mailbox_settings.dart';

const String mailboxesSettingsBoxName = "mailboxesSettings";

class HiveManager {
  HiveManager._privateConstructor();

  static final HiveManager _instance = HiveManager._privateConstructor();
  bool initDone = false;
  factory HiveManager() {
    return _instance;
  }

  init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(MailboxSettingsAdapter());
    var allMailboxes = await Hive.openBox<MailboxSettings>(mailboxesSettingsBoxName);
    if (allMailboxes.isEmpty) {
      //add default one if it's empty
      allMailboxes.add(MailboxSettings("userName", "password", "imap url", 993, true, "mail@example.com", true));
    }
    initDone = true;
  }
}
