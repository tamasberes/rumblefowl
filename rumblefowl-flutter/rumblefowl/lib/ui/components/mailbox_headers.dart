import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:logging/logging.dart';
import 'package:rumblefowl/ui/components/elevated_button_with_margin.dart';

import '../../services/db/hive_manager.dart';
import '../../services/db/mailbox_settings.dart';

final log = Logger('MailboxesHeader');

//Lists the available mailboxes
class MailboxesHeader extends StatelessWidget {
  const MailboxesHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box<MailboxSettings>(mailboxesSettingsBoxName).listenable(),
        builder: (context, Box<MailboxSettings> box, _) {
          if (box.values.isEmpty) {
            return const Center(
              child: Text("No mailboxesSettings"),
            );
          }
          return ListView.builder(
              shrinkWrap: true,
              itemCount: box.values.length,
              itemBuilder: (context, index) {
                MailboxSettings currentItem = box.getAt(index)!;
                return ElevatedButtonWithMargin(
                    buttonText: currentItem.emailAddress,
                    onPressedAction: () {
                      log.info("mailbox clicked${currentItem.emailAddress}");
                    });
              });
        });
  }
}
