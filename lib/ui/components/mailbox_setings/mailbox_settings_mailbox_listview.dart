import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';
import '../../../services/db/hive_manager.dart';
import '../../../services/db/mailbox_settings.dart';
import 'mailbox_settings_dialog.dart';

final log = Logger('MailboxListWidget');

class MailboxSettingsMailboxListview extends StatefulWidget {
  const MailboxSettingsMailboxListview({Key? key}) : super(key: key);

  //the fix did not work https://stackoverflow.com/questions/72677634/avoid-using-private-types-in-public-apis-warning-in-flutter
  @override
  // ignore: library_private_types_in_public_api 
  _MailboxSettingsMailboxListviewState createState() => _MailboxSettingsMailboxListviewState();
}

class _MailboxSettingsMailboxListviewState extends State<MailboxSettingsMailboxListview> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box<MailboxSettings>(mailboxesSettingsBoxName).listenable(),
        builder: (context, Box<MailboxSettings> box, _) {
          if (box.values.isEmpty) {
            return const Center(
              child: Text("No mailboxes"),
            );
          }
          return Container(
            padding:  const EdgeInsets.all(paddingWidgetEdges),
            child: ListView.builder(
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
                }),
          );
        });
  }
}
