import 'package:hive_flutter/hive_flutter.dart';
import 'package:rumblefowl/services/db/email_object.dart';
import 'package:rumblefowl/services/db/mailbox_folder.dart';

import 'mailbox_settings.dart';
import 'package:uuid/uuid.dart';

const String mailboxesSettingsBoxName = "mailboxesSettingsBoxName";
const String mailObjectSettingsBoxName = "mailObjectSettingsBoxName";
const String mailboxFolderBoxName = "mailboxFolderBoxName";

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
    Hive.registerAdapter(EmailObjectAdapter());
    Hive.registerAdapter(MailboxFolderAdapter());

    var allMailboxes = await Hive.openBox<MailboxSettings>(mailboxesSettingsBoxName);
    if (allMailboxes.isEmpty) {
      //add default one if it's empty
      var uuid = const Uuid();
      await allMailboxes.put(uuid.v4(), MailboxSettings("userName", "password", "imap url", 993, true, "mail@example.com"));
    }
    await Hive.openBox<EmailObject>(mailObjectSettingsBoxName);
    await Hive.openBox<MailboxFolder>(mailboxFolderBoxName);
    initDone = true;
  }
}
