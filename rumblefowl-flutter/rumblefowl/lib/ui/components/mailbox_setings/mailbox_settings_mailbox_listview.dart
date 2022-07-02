import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import '../../../services/mail/hive_manager.dart';
import '../../../services/mail/mailbox_settings.dart';
import 'mailbox_settings_dialog.dart';

final log = Logger('MailboxListWidget');

class MailboxSettingsMailboxListview extends StatefulWidget {
  const MailboxSettingsMailboxListview({Key? key}) : super(key: key);

  @override
  _MailboxSettingsMailboxListviewState createState() => _MailboxSettingsMailboxListviewState();
}

class _MailboxSettingsMailboxListviewState extends State<MailboxSettingsMailboxListview> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey.shade300,
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

                        Provider.of<SelectedMailboxWithNotifier>(context, listen: false).selectedMailbox = currentItem;
                      },
                    );
                  });
            }));
  }
}
