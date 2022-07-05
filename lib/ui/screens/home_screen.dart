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
    return Scaffold(
        body: Column(children: [
      const MailActionsHeader(),
      const MailboxesHeader(),
      Expanded(
          child: Row(
        children: const [
          MailboxFolders(),
          EmailList(),
          Expanded(child: MailView()),
        ],
      )),
    ]));
  }
}
