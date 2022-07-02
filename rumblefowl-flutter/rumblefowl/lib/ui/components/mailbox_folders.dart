
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'elevated_button_with_margin.dart';

final log = Logger('MailboxFolders');

//shows the available mailbox folders for a selected mailbox (or all)
class MailboxFolders extends StatelessWidget {
  const MailboxFolders({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButtonWithMargin(
          buttonText: 'mail folders',
          onPressedAction: () {
            log.info("All Mail");
          },
        ),
        ElevatedButtonWithMargin(
          buttonText: 'here are the folders of a mailbox',
          onPressedAction: () {
            log.info("All Mail");
          },
        ),
        ElevatedButtonWithMargin(
          buttonText: 'All Mail',
          onPressedAction: () {
            log.info("All Mail");
          },
        ),
        ElevatedButtonWithMargin(
          buttonText: 'All Mail',
          onPressedAction: () {
            log.info("All Mail");
          },
        ),
        ElevatedButtonWithMargin(
          buttonText: 'All Mail',
          onPressedAction: () {
            log.info("All Mail");
          },
        ),
      ],
    );
  }
}
