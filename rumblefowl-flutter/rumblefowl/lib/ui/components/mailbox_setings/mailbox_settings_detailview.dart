import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:rumblefowl/main.dart';

import '../../../services/mail/hive_manager.dart';
import '../../../services/mail/mailbox_settings.dart';
import 'mailbox_settings_dialog.dart';

final log = Logger('MailboxSettingsDetailView');

class MailboxSettingsDetailView extends StatefulWidget {
  const MailboxSettingsDetailView({Key? key}) : super(key: key);

  @override
  State<MailboxSettingsDetailView> createState() => _MailboxSettingsDetailViewState();
}

class _MailboxSettingsDetailViewState extends State<MailboxSettingsDetailView> {
  @override
  Widget build(BuildContext context) {
    //set initial value
    var myControllerEmail = TextEditingController(text: Provider.of<SelectedMailboxWithNotifier>(context, listen: false).selectedMailbox.emailAddress);
    //watch changes from external source
    myControllerEmail.text = context.watch<SelectedMailboxWithNotifier>().selectedMailbox.emailAddress;

    //set initial value
    var myControllerUsername = TextEditingController(text: Provider.of<SelectedMailboxWithNotifier>(context, listen: false).selectedMailbox.userName);
    //watch changes from external source
    myControllerUsername.text = context.watch<SelectedMailboxWithNotifier>().selectedMailbox.userName;

    //set initial value
    var myControllerPassword = TextEditingController(text: Provider.of<SelectedMailboxWithNotifier>(context, listen: false).selectedMailbox.password);
    //watch changes from external source
    myControllerPassword.text = context.watch<SelectedMailboxWithNotifier>().selectedMailbox.password;

    //set initial value
    var myControllerImapUrl = TextEditingController(text: Provider.of<SelectedMailboxWithNotifier>(context, listen: false).selectedMailbox.imapUrl);
    //watch changes from external source
    myControllerImapUrl.text = context.watch<SelectedMailboxWithNotifier>().selectedMailbox.imapUrl;

    //set initial value
    var myControllerImapPort = TextEditingController(text: Provider.of<SelectedMailboxWithNotifier>(context, listen: false).selectedMailbox.imapPort.toString());
    //watch changes from external source
    myControllerImapPort.text = context.watch<SelectedMailboxWithNotifier>().selectedMailbox.imapPort.toString();

    return SingleChildScrollView(
        controller: ScrollController(),
        child: Container(
            padding: const EdgeInsets.all(paddingWidgetEdges),
            color: Colors.grey.shade200,
            child: FocusTraversalGroup(
              child: Form(
                  autovalidateMode: AutovalidateMode.always,
                  onChanged: () {
                    Form.of(primaryFocus!.context!)!.save();
                  },
                  child: Column(children: [
                    TextFormField(
                      controller: myControllerEmail,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.mail),
                        hintText: 'E-Mail address',
                        helperText: 'The E-mail address associated with this account',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (String? value) {
                        log.info('Value for field saved as "$value"');
                        Provider.of<SelectedMailboxWithNotifier>(context, listen: false).selectedMailbox.emailAddress = value!;
                      },
                    ),
                    const SizedBox(height: spacingBetweenItemsVertical),
                    TextFormField(
                      controller: myControllerUsername,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        hintText: 'Username',
                        helperText: 'The Username associated with this account',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (String? value) {
                        log.info('Value for field saved as "$value"');
                        Provider.of<SelectedMailboxWithNotifier>(context, listen: false).selectedMailbox.userName = value!;
                      },
                    ),
                    const SizedBox(height: spacingBetweenItemsVertical),
                    TextFormField(
                      controller: myControllerPassword,
                      obscureText: true,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.lock),
                        hintText: 'Password',
                        helperText: 'The Password associated with this account',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (String? value) {
                        log.info('Value for field saved as "$value"');
                        Provider.of<SelectedMailboxWithNotifier>(context, listen: false).selectedMailbox.password = value!;
                      },
                    ),
                    const SizedBox(height: spacingBetweenItemsVertical),
                    TextFormField(
                      controller: myControllerImapUrl,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.link),
                        hintText: 'IMAP Url',
                        helperText: 'The IMAP Url of the E-mail Provider',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (String? value) {
                        log.info('Value for field saved as "$value"');
                        Provider.of<SelectedMailboxWithNotifier>(context, listen: false).selectedMailbox.imapUrl = value!;
                      },
                    ),
                    const SizedBox(height: spacingBetweenItemsVertical),
                    TextFormField(
                      controller: myControllerImapPort,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.info),
                        hintText: 'IMAP Port',
                        helperText: 'The IMAP Port number of the E-mail Provider',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (String? value) {
                        log.info('Value for field saved as "$value"');
                        Provider.of<SelectedMailboxWithNotifier>(context, listen: false).selectedMailbox.imapPort = int.parse(value!);
                      },
                    ),
                    const SizedBox(height: spacingBetweenItemsVertical),
                    Row(children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 18, 0), //to match spacing with the above items
                        child: const Icon(Icons.info),
                      ),
                      const Text("Use SSL"),
                      Checkbox(
                          value: Provider.of<SelectedMailboxWithNotifier>(context).selectedMailbox.useTls,
                          onChanged: (bool? value) {
                            // This is where we update the state when the checkbox is tapped
                            setState(() {
                              Provider.of<SelectedMailboxWithNotifier>(context, listen: false).selectedMailbox.useTls = value!;
                            });
                          })
                    ])
                  ])),
            )));
  }
}
