import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:logging/logging.dart';
import 'package:rumblefowl/ui/components/elevated_button_with_margin.dart';

import '../../services/db/hive_manager.dart';
import '../../services/db/mailbox_settings.dart';
import '../../services/prerferences/preferences_manager.dart';

final log = Logger('MailboxesHeader');

//Lists the available mailboxes
class MailboxesHeader extends StatefulWidget {
  const MailboxesHeader({
    Key? key,
  }) : super(key: key);

  @override
  State<MailboxesHeader> createState() => _MailboxesHeaderState();
}

class _MailboxesHeaderState extends State<MailboxesHeader> {
  int selectedIndex = PreferencesManager().getSelectedMailbox();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box<MailboxSettings>(mailboxesSettingsBoxName).listenable(),
        builder: (context, Box<MailboxSettings> box, _) {
          if (box.values.isEmpty) {
            return const Center(
              child: Text("Please set up a mailbox first!"),
            );
          }
          return ConstrainedBox(
              constraints: const BoxConstraints(
                //had to set height in advance, lazy listview size would be 0 at start
                minHeight: 5.0,
                maxHeight: 48.0,
              ),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: box.values.length,
                  itemBuilder: (context, index) {
                    MailboxSettings currentItem = box.getAt(index)!;
                    return ElevatedButtonWithMargin(
                        isHighlighted: selectedIndex == index,
                        buttonText: currentItem.emailAddress,
                        onPressedAction: () {
                          log.info("mailbox clicked${currentItem.emailAddress}");

                          setState(() {
                            selectedIndex = index;
                          });
                          PreferencesManager().setSelectedMailbox(index);

                        });
                  }));
        });
  }
}
