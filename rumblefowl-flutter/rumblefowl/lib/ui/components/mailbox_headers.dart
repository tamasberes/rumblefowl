import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'elevated_button_with_margin.dart';
final log = Logger('MailboxesHeader');

//Lists the available mailboxes
class MailboxesHeader extends StatelessWidget {
  const MailboxesHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.deepPurple.shade700,
        child: Row(
          children: [
            ElevatedButtonWithMargin(
              buttonText: 'All Mail',
              onPressedAction: () {
                log.info("All Mail");
              },
            ),
            ElevatedButtonWithMargin(
              buttonText: 'mailbox1@gmail.com',
              onPressedAction: () {
                log.info("mailbox1@gmail.com clicked");
              },
            ),
            ElevatedButtonWithMargin(
              buttonText: 'mailbox12231@gmail.com',
              onPressedAction: () {
                log.info("mailbox12231@gmail.com clicked");
              },
            )
          ],
        ));
  }
}