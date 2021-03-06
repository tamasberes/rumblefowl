//Top most menu bar. Always shown. Always relates to the selected mailbox
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:rumblefowl/services/prerferences/preferences_manager.dart';
import 'package:rumblefowl/ui/components/mailbox_setings/mailbox_settings_dialog.dart';

import '../new_mail/compose_new_mail.dart';
import '../widgets/elevated_button_with_margin.dart';

final log = Logger('MailActionsHeader');

class MailActionsHeader extends StatelessWidget {
  const MailActionsHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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

            openNewMailDialog(context);
          },
        ),
        ElevatedButtonWithMargin(
            buttonText: 'Setup E-Mail accounts',
            onPressedAction: () {
              log.info("Setup E-Mail accounts clicked");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MailboxSettingsDialog()),
              );
            }),
        ElevatedButtonWithMargin(
          buttonText: 'Search',
          onPressedAction: () {
            log.info("Search clicked");
          },
        ),
        Spacer(flex: 1),
        IconButton(
            onPressed: () {
              PreferencesManager().toggleDarkMode();
            },
            icon: Icon(Icons.brightness_1))
      ],
    );
  }

  void openNewMailDialog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ComposeNewMailWindow()),
    );
  }
}
