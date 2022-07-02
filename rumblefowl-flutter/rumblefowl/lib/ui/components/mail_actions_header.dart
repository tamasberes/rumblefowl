//Top most menu bar. Always shown. Always relates to the selected mailbox
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:rumblefowl/ui/components/mailbox_settings_dialog.dart';
import 'elevated_button_with_margin.dart';

final log = Logger('MailActionsHeader');

class MailActionsHeader extends StatelessWidget {
  const MailActionsHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.deepPurple.shade900,
        child: Row(
          children: [
            ElevatedButtonWithMargin(
              buttonText: 'Sync mail',
              onPressedAction: () {
                log.info("sync mail clicked");
              },
            ),
            ElevatedButtonWithMargin(
              buttonText: 'New E-Mail',
              onPressedAction: () {
                log.info("New E-Mail clicked");
              },
            ),
            ElevatedButtonWithMargin(
              buttonText: 'Setup E-Mail accounts',
              onPressedAction: () {
                log.info("Setup E-Mail accounts clicked");

                Navigator.of(context).push(new MaterialPageRoute<Null>(
                    builder: (BuildContext context) {
                      return new MailboxSettingsDialog();
                    },
                    fullscreenDialog: false));
              },
            ),
            ElevatedButtonWithMargin(
              buttonText: 'Search',
              onPressedAction: () {
                log.info("Search clicked");
              },
            )
          ],
        ));
  }
}
