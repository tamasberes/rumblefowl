import 'dart:collection';

import 'package:enough_mail/enough_mail.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logging/logging.dart';
import 'package:rumblefowl/services/db/hive_manager.dart';
import 'package:rumblefowl/services/db/mailbox_folder.dart';

import '../db/email_object.dart';
import '../db/mailbox_settings.dart';

final log = Logger('MailSync');

///UI does not do network calls,
///
class MailSync {
  HashMap<MailboxSettings, MailClient> loggedInMailboxes = HashMap<MailboxSettings, MailClient>();

  init() async {
    //log in with all mailboxes
    var allMailboxes = await Hive.openBox<MailboxSettings>(mailboxesSettingsBoxName);
    for (var i = 0; i < allMailboxes.length; i++) {
      var mailbox = allMailboxes.getAt(i)!;
      //login
      try {
        final config = await Discover.discover(mailbox.emailAddress);
        if (config == null) {
          log.warning('Unable to auto-discover settings for $mailbox.emailAddress');
          throw BaseMailException("Unable to auto-discover settings for $mailbox.emailAddress");
        }
        log.info('connecting to ${config.displayName}.');
        final account = MailAccount.fromDiscoveredSettings('my account', mailbox.emailAddress, mailbox.password, config);
        final mailClient = MailClient(
          account,
          isLogEnabled: false,
          onBadCertificate: (p0) {
            return true;
          },
        );
        await mailClient.connect();

        log.info('connected');
        loggedInMailboxes[mailbox] = mailClient;
        log.info("logged in mailbox: ${mailbox.emailAddress}");

        syncMailbox(mailClient);

        //start sync with that mailbox
        //syncMailbox(mailbox, mailClient);
      } catch (e) {
        if (e is BaseMailException) {
          log.warning(e.message);
        } else {
          log.warning(e);
        }
      }
    }
  }

  ///download everything for a mailbox
  ///emails, folders, attachments, etc
  Future<void> syncMailbox(MailClient mailClient) async {
    var mailboxes = await mailClient.listMailboxes();
    for (var mailbox in mailboxes) {
      var messages = await (mailClient).fetchMessages(mailbox: mailbox, fetchPreference: FetchPreference.full); //FIXME pagination
      log.info("received emails:${mailbox.path} count:${messages.length}");
      //put them into the db
      for (var message in messages) {
        await Hive.box<EmailObject>(mailObjectSettingsBoxName).put(message.guid, EmailObject(message.toString(), mailClient.account.email!, mailbox.path, message.guid!));
      }
      //store all flags as a single string
      var flags = "";
      for (var element in mailbox.flags) {
        flags+="${element.name}#flagseperator";
      }
      await Hive.box<MailboxFolder>(mailboxFolderBoxName).put(getUniqueIdForFolder(mailClient, mailbox), MailboxFolder(mailClient.account.email!, mailbox.name, flags, mailbox.messagesExists));
    }
    //FIXME this should merge the new data together with the existing data

    //send pending mail

    //upload drafts

    //anything else?
  }

  getUniqueIdForFolder(MailClient mailClient, Mailbox mailbox) {
    return mailClient.account.email! + mailbox.path; //FIXME this is not a great choice for a unique id. what if the user adds another account with the same email address?
  }
}
