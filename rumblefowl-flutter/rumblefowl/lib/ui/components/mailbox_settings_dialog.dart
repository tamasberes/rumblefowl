import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import '../../services/mail/hive_manager.dart';
import '../../services/mail/mailbox_settings.dart';

final log = Logger('MailboxSettingsDialog');


class SelectedMailboxWithNotifier with ChangeNotifier {
  MailboxSettings _selectedMailbox;

  MailboxSettings get selectedMailbox => _selectedMailbox;

  set selectedMailbox(MailboxSettings selectedMailbox) {
    _selectedMailbox = selectedMailbox;
    notifyListeners();
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
    SelectedMailboxWithNotifier changeNotifierProviderInstance=SelectedMailboxWithNotifier(Hive.box<MailboxSettings>(mailboxesSettingsBoxName).getAt(0)!);

    return Scaffold(
        appBar: AppBar(title: const Text("Mailbox settings")),
        body: 
        ChangeNotifierProvider(
          create: (_) => changeNotifierProviderInstance,
            child: 
        
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(child: MailboxListWidget()),
                      Expanded(
                        child: MailboxSettingsSetupView(),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
      )
    );
  }

  indexChanged(int value) {
    log.info("index changed in parent:$value");
  }

  int getCurrentIndex() {
    return 0;
  }
}

class MailboxSettingsSetupView extends StatefulWidget {
  const MailboxSettingsSetupView({Key? key}) : super(key: key);

  @override
  State<MailboxSettingsSetupView> createState() => _MailboxSettingsSetupViewState();
}

class _MailboxSettingsSetupViewState extends State<MailboxSettingsSetupView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepPurple.shade300,
      child: Text(context.watch<SelectedMailboxWithNotifier>().selectedMailbox.emailAddress),
    );
  }
}

class MailboxListWidget extends StatefulWidget {
  const MailboxListWidget({Key? key}) : super(key: key);

  @override
  _MailboxListWidgetState createState() => _MailboxListWidgetState();
}

class _MailboxListWidgetState extends State<MailboxListWidget> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.deepPurple.shade200,
        child: ValueListenableBuilder(
            valueListenable: Hive.box<MailboxSettings>(mailboxesSettingsBoxName).listenable(),
            builder: (context, Box<MailboxSettings> box, _) {
              if (box.values.isEmpty) {
                return const Center(
                  child: Text("No mailboxes"),
                );
              }
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: box.values.length,
                  itemBuilder: (context, index) {
                    MailboxSettings currentItem = box.getAt(index)!;
                    return ListTile(
                      enableFeedback: true, visualDensity: VisualDensity.compact,
                      selected: selectedIndex == index,
                      //  selectedColor: Colors.redAccent,
                      leading: const Icon(Icons.email),
                      title: Text(currentItem.emailAddress),
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                        log.info("item clicked:${currentItem.emailAddress}");

                        Provider.of<SelectedMailboxWithNotifier>(context, listen: false).selectedMailbox=currentItem;
                      },
                    );
                  });
            }));
  }
}
