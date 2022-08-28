import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:rumblefowl/ui/components/home/mailbox_folders.dart';

import '../components/home/email_list.dart';
import '../components/home/mail_actions_header.dart';
import '../components/home/mail_view.dart';
import '../components/home/mailbox_headers.dart';

final log = Logger('HomeWidget');

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const MailActionsHeader(),
      const Divider(height: 2),
      const MailboxesHeader(),
      const Divider(height: 2),
      Expanded(
          child: Row(
        children: const [
          MailboxFolders(),
          EmailList(),
          Expanded(child: MailView()),
        ],
      )),
    ]);
  }
}

class RumbleHorizontalDivider extends StatelessWidget {
  const RumbleHorizontalDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 2.0,
      thickness: 2.0,
      color: Theme.of(context).colorScheme.secondary,
    );
  }
}

class RumbleVerticalDivider extends StatelessWidget {
  const RumbleVerticalDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VerticalDivider(
      width: 2.0,
      thickness: 2.0,
      color: Theme.of(context).colorScheme.secondary,
    );
  }
}
