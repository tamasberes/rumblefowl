//lists folders inside of a mailbox
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'elevated_button_with_margin.dart';

final log = Logger('FolderContent');

class FolderContent extends StatelessWidget {
  const FolderContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButtonWithMargin(
          buttonText: 'FOLDERSCONTENT',
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
