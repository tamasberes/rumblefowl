import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import '../../../services/db/hive_manager.dart';
import '../../../services/db/mailbox_settings.dart';
import '../../../services/mail/mail_helper.dart';
import '../../../services/prerferences/preferences_manager.dart';
import '../../util/scrollcontroller.dart';
import '../widgets/utils.dart';

final log = Logger('FolderContent');

class EmailList extends StatefulWidget {
  const EmailList({
    Key? key,
  }) : super(key: key);

  @override
  State<EmailList> createState() => _EmailListState();
}

class _EmailListState extends State<EmailList> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    PreferencesManager changeNotifierProviderInstance = PreferencesManager();

    return ChangeNotifierProvider(
        create: (_) => changeNotifierProviderInstance,
        child: Consumer<PreferencesManager>(
          builder: (context, value, child) => FutureBuilder<List<MimeMessage>>(
              future: MailHelper().getFolderContent(Hive.box<MailboxSettings>(mailboxesSettingsBoxName).getAt(changeNotifierProviderInstance.getSelectedMailbox())!, changeNotifierProviderInstance.getSelectedFolder()),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  log.warning(snapshot.error);
                  return Text('Error ${snapshot.error}');
                }
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return const Text('No emails found');
                }
                return ConstrainedBox(
                    constraints: const BoxConstraints(
                        //had to set height in advance, lazy listview size would be 0 at start
                        minHeight: 5.0,
                        minWidth: 50,
                        maxWidth: 260.0),
                    child: ListView.builder(
                        controller: AdjustableScrollController(),
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          var currentItem = snapshot.data?[index];
                          return ListTile(
                              selectedTileColor: changeNotifierProviderInstance.getIsDarkMode() ? listItemSelectedBackgroundColorDark : listItemSelectedBackgroundColor,
                              isThreeLine: true,
                              title: Text(currentItem!.decodeSubject()!, overflow: TextOverflow.ellipsis, maxLines: 1, style: currentItem.isSeen ? const TextStyle(fontWeight: FontWeight.normal) : const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                "${currentItem.fromEmail!}\n${DateFormat.yMMMMd().add_Hms().format(currentItem.decodeDate()!)}",
                                style: currentItem.isSeen ? const TextStyle(fontWeight: FontWeight.normal) : const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              selected: selectedIndex == index,
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                                log.info("selected item:${currentItem.guid}");
                                PreferencesManager().setSelectedMailGuid(currentItem.guid!);
                              });
                        }));
              }),
        ));
  }
}
