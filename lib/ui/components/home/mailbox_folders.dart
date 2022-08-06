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
import '../widgets/utils.dart';

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

    var snapshot = MailHelper().getFoldersForMailbox(Hive.box<MailboxSettings>(mailboxesSettingsBoxName).getAt(changeNotifierProviderInstance.getSelectedMailbox())!);

    return ChangeNotifierProvider(
        create: (_) => changeNotifierProviderInstance,
        child: ConstrainedBox(
            constraints: const BoxConstraints(
                //had to set height in advance, lazy listview size would be 0 at start
                minHeight: 5.0,
                minWidth: 5,
                maxWidth: 232),
            child: ListView.builder(
                controller: AdjustableScrollController(),
                itemCount: snapshot.length,
                itemBuilder: (context, index) {
                  var currentItem = snapshot[index];
                  return ListTile(
                      leading: const Icon(Icons.folder),
                      selected: selectedIndex == index,
                      selectedTileColor: changeNotifierProviderInstance.getIsDarkMode() ? listItemSelectedBackgroundColorDark : listItemSelectedBackgroundColor,
                      title: Text(currentItem.folderName),
                      onTap: () {
                        log.info("mailbox clicked$currentItem");

                        setState(() {
                          selectedIndex = index;
                          PreferencesManager().setSelectedFolder(currentItem.folderName);
                        });
                      });
                })));
  }
}
