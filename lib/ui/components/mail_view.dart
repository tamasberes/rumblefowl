
//based on selected mail item, shows html content and reply stuff
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'elevated_button_with_margin.dart';
final log = Logger('MailView');

class MailView extends StatelessWidget {
  const MailView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
    children: [
      ElevatedButtonWithMargin(
        buttonText: 'MAILVIEW',
        onPressedAction: () {
          log.info("All Mail");
        },
      ),
    ],
     );
  }
}