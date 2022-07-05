import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:rumblefowl/services/mail/mail_helper.dart';
import 'package:rumblefowl/services/prerferences/preferences_manager.dart';

import '../../../services/db/hive_manager.dart';
import '../../../services/db/mailbox_settings.dart';
import '../../util/scrollcontroller.dart';
import '../widgets/elevated_button_with_margin.dart';

final log = Logger('MailboxFolders');

//shows the available mailbox folders for a selected mailbox (or all)
class MailboxFolders extends StatefulWidget {
  const MailboxFolders({
    Key? key,
  }) : super(key: key);

  @override
  State<MailboxFolders> createState() => _MailboxFoldersState();
}

class _MailboxFoldersState extends State<MailboxFolders> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    PreferencesManager changeNotifierProviderInstance = PreferencesManager();

    return ChangeNotifierProvider(
        create: (_) => changeNotifierProviderInstance,
        child: Consumer<PreferencesManager>(
          builder: (context, value, child) => FutureBuilder<List<Mailbox>>(
              future: MailHelper().getFoldersForMailbox(Hive.box<MailboxSettings>(mailboxesSettingsBoxName).getAt(changeNotifierProviderInstance.getSelectedMailbox())!),
              builder: (context, snapshot) {
                if (snapshot.hasError) return Text('Error ${snapshot.error}');
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return ConstrainedBox(
                    constraints: const BoxConstraints(
                        //had to set height in advance, lazy listview size would be 0 at start
                        minHeight: 5.0,
                        minWidth: 50,
                        maxWidth: 232),
                    child: ListView.builder(
                        controller: AdjustableScrollController(),
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          var currentItem = snapshot.data?[index];
                          return ElevatedButtonWithMargin(
                              isHighlighted: selectedIndex == index,
                              buttonText: currentItem!.path,
                              onPressedAction: () {
                                log.info("mailbox clicked${currentItem.path}");

                                setState(() {
                                  selectedIndex = index;
                                  PreferencesManager().setSelectedFolder(currentItem.name);
                                });
                              });
                        }));
              }),
        ));
  }
}
