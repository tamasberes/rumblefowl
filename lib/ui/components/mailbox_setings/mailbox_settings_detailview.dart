import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:rumblefowl/main.dart';
import 'package:rumblefowl/ui/components/widgets/elevated_button_with_margin.dart';

import '../../../services/mail/mail_helper.dart';
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
    var myControllerEmail = TextEditingController(text: Provider.of<SelectedMailboxWithNotifier>(context, listen: false).selectedMailbox.emailAddress);
    myControllerEmail.text = context.watch<SelectedMailboxWithNotifier>().selectedMailbox.emailAddress;

    var myControllerUsername = TextEditingController(text: Provider.of<SelectedMailboxWithNotifier>(context, listen: false).selectedMailbox.userName);
    myControllerUsername.text = context.watch<SelectedMailboxWithNotifier>().selectedMailbox.userName;

    var myControllerPassword = TextEditingController(text: Provider.of<SelectedMailboxWithNotifier>(context, listen: false).selectedMailbox.password);
    myControllerPassword.text = context.watch<SelectedMailboxWithNotifier>().selectedMailbox.password;

    var myControllerImapUrl = TextEditingController(text: Provider.of<SelectedMailboxWithNotifier>(context, listen: false).selectedMailbox.imapUrl);
    myControllerImapUrl.text = context.watch<SelectedMailboxWithNotifier>().selectedMailbox.imapUrl;

    var myControllerImapPort = TextEditingController(text: Provider.of<SelectedMailboxWithNotifier>(context, listen: false).selectedMailbox.imapPort.toString());
    myControllerImapPort.text = context.watch<SelectedMailboxWithNotifier>().selectedMailbox.imapPort.toString();

    return SingleChildScrollView(
        controller: ScrollController(),
        child: Container(
            padding: const EdgeInsets.all(paddingWidgetEdges),
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
                        Provider.of<SelectedMailboxWithNotifier>(context, listen: false).valuesUpdated();
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
                        Provider.of<SelectedMailboxWithNotifier>(context, listen: false).valuesUpdated();
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
                        Provider.of<SelectedMailboxWithNotifier>(context, listen: false).valuesUpdated();
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
                        Provider.of<SelectedMailboxWithNotifier>(context, listen: false).valuesUpdated();
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
                        Provider.of<SelectedMailboxWithNotifier>(context, listen: false).valuesUpdated();
                      },
                    ),
                    const SizedBox(height: spacingBetweenItemsVertical),
                    Row(children: [
                      Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 18, 0), //to match spacing with the above items
                          child: Icon(
                            Icons.security,
                            color: Colors.grey.shade600, //same color as the others
                          )),
                      const Text("Use SSL"),
                      Checkbox(
                          value: Provider.of<SelectedMailboxWithNotifier>(context).selectedMailbox.useTls,
                          onChanged: (bool? value) {
                            // This is where we update the state when the checkbox is tapped
                            setState(() {
                              Provider.of<SelectedMailboxWithNotifier>(context, listen: false).selectedMailbox.useTls = value!;
                              Provider.of<SelectedMailboxWithNotifier>(context, listen: false).valuesUpdated();
                            });
                          })
                    ]),
                    const SizedBox(height: spacingBetweenItemsVertical),
                    const TryMailSettingsWidget()
                  ])),
            )));
  }
}

class TryMailSettingsWidget extends StatelessWidget {
  const TryMailSettingsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButtonWithMargin(
        onPressedAction: () {
          AlertDialog alert = AlertDialog(
            content: Row(
              children: [
                const CircularProgressIndicator(),
                Container(margin: const EdgeInsets.only(left: 7), child: const Text("Loading...")),
              ],
            ),
          );
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return alert;
            },
          );

          log.info("Try settings clicked");
          MailHelper().login(Provider.of<SelectedMailboxWithNotifier>(context, listen: false).selectedMailbox).then((value) {
            showSnackbar(Colors.green, Colors.white, "Login succesful!", context);
          }).onError((error, stackTrace) {
            showSnackbar(Colors.red, Colors.white, "Login failed. Please check your settings!", context);
          });
        },
        buttonText: "Try settigns");
  }

  showSnackbar(Color backgroundColor, Color textColor, String text, BuildContext context) {
    Navigator.pop(context);
    var snackBar = SnackBar(
      width: 300.0,
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      content: Text(
        text,
        style: TextStyle(
          color: textColor,
        ),
      ),
    );
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
