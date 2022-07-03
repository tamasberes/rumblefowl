import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import '../../services/db/hive_manager.dart';
import '../../services/db/mailbox_settings.dart';
import '../../services/mail/mail_helper.dart';
import '../../services/prerferences/preferences_manager.dart';
import '../util/scrollcontroller.dart';

final log = Logger('MailView');

class MailView extends StatefulWidget {
  const MailView({
    Key? key,
  }) : super(key: key);

  @override
  State<MailView> createState() => _MailViewState();
}

class _MailViewState extends State<MailView> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    PreferencesManager changeNotifierProviderInstance = PreferencesManager();

    return ChangeNotifierProvider(
        create: (_) => changeNotifierProviderInstance,
        child: Consumer<PreferencesManager>(
          builder: (context, value, child) => FutureBuilder<MimeMessage>(
              future: MailHelper().getMail(Hive.box<MailboxSettings>(mailboxesSettingsBoxName).getAt(changeNotifierProviderInstance.getSelectedMailbox())!, PreferencesManager().getSelectedFolder(), PreferencesManager().getSelectedMailGuid()),
              builder: (context, snapshot) {
                if (snapshot.hasError) return Text('Error ${snapshot.error}');
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return Column(children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("From:"),
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(snapshot.data!.fromEmail!),
                      )],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("To:"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(snapshot.data!.to.toString()!),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Subject:"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(snapshot.data!.decodeSubject()!),
                      )
                    ],
                  ),

                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Body:"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(snapshot.data!.renderMessage()!),
                      )
                    ],
                  )
                ]);
              }),
        ));
  }
}
