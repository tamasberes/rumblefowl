import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import '../../../services/db/hive_manager.dart';
import '../../../services/db/mailbox_settings.dart';
import 'mailbox_settings_detailview.dart';
import 'mailbox_settings_mailbox_listview.dart';

final log = Logger('MailboxSettingsDialog');

class SelectedMailboxWithNotifier with ChangeNotifier {
  MailboxSettings _selectedMailbox;

  MailboxSettings get selectedMailbox => _selectedMailbox;

  set selectedMailbox(MailboxSettings selectedMailbox) {
    _selectedMailbox = selectedMailbox;
    notifyListeners();
  }

  valuesUpdated() {
    selectedMailbox.save().then((value) => log.info("values are now persisted"));
  }

  SelectedMailboxWithNotifier(this._selectedMailbox);
}

class MailboxSettingsDialog extends StatefulWidget {
  const MailboxSettingsDialog({Key? key}) : super(key: key);

  @override
  State<MailboxSettingsDialog> createState() => _MailboxSettingsDialogState();
}

class _MailboxSettingsDialogState extends State<MailboxSettingsDialog> {
  @override
  Widget build(BuildContext context) {
    SelectedMailboxWithNotifier changeNotifierProviderInstance = SelectedMailboxWithNotifier(Hive.box<MailboxSettings>(mailboxesSettingsBoxName).getAt(0)!);

    return Scaffold(
        appBar: AppBar(title: const Text("Mailbox settings")),
        body: ChangeNotifierProvider(
          create: (_) => changeNotifierProviderInstance,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const [
                    Expanded(child: MailboxSettingsMailboxListview()),
                    VerticalDivider(),
                    Expanded(
                      child: MailboxSettingsDetailView(),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  indexChanged(int value) {
    log.info("index changed in parent:$value");
  }

  int getCurrentIndex() {
    return 0;
  }
}
