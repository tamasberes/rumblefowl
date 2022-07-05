import 'dart:collection';

import 'package:enough_mail/enough_mail.dart';
import 'package:logging/logging.dart';
import '../db/mailbox_settings.dart';

final log = Logger('MailboxesHeader');

class MailHelper {
  HashMap<String, MailClient> loggedInMailboxes = HashMap<String, MailClient>();

  Future<MailClient> login(MailboxSettings mailbox) async {
    final config = await Discover.discover(mailbox.emailAddress);
    if (config == null) {
      // note that you can also directly create an account when
      // you cannot auto-discover the settings:
      // Compare the [MailAccount.fromManualSettings]
      // and [MailAccount.fromManualSettingsWithAuth]
      // methods for details.
      log.warning('Unable to auto-discover settings for $mailbox.emailAddress');
      throw BaseMailException("Unable to auto-discover settings for $mailbox.emailAddress");
    }
    log.info('connecting to ${config.displayName}.');
    final account = MailAccount.fromDiscoveredSettings('my account', mailbox.emailAddress, mailbox.password, config);
    final mailClient = MailClient(account, isLogEnabled: false);
    try {
      await mailClient.connect();
      log.info('connected');
      loggedInMailboxes[mailbox.emailAddress] = mailClient;
      return mailClient;
    } on MailException catch (e) {
      log.info('High level API failed with $e');
      rethrow;
    }
  }

  Future<List<Mailbox>> getFoldersForMailbox(MailboxSettings mailbox) async {
    if (!loggedInMailboxes.containsKey(mailbox.emailAddress)) {
      await login(mailbox);
    }
    return await loggedInMailboxes[mailbox.emailAddress]!.listMailboxes();
  }

  Future<List<MimeMessage>> getFolderContent(MailboxSettings mailboxSettings, String folder) async {
    var mailbox = await getFoldersForMailbox(mailboxSettings);
    return await loggedInMailboxes[mailboxSettings.emailAddress]!.fetchMessages(mailbox: mailbox.firstWhere((element) => element.name == folder));
  }

  Future<MimeMessage> getMail(MailboxSettings mailboxSettings, String folder, int guid) async {
    var mailbox = await getFoldersForMailbox(mailboxSettings);
    var messagesInSelectedFolder = await loggedInMailboxes[mailboxSettings.emailAddress]!.fetchMessages(fetchPreference: FetchPreference.full, mailbox: mailbox.firstWhere((element) => element.name == folder));
    return messagesInSelectedFolder.firstWhere((element) => element.guid == guid);
  }
}