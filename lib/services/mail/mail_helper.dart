import 'package:enough_mail/enough_mail.dart';
import 'package:hive/hive.dart';
import 'package:logging/logging.dart';
import 'package:rumblefowl/services/db/email_object.dart';
import 'package:rumblefowl/ui/components/new_mail/compose_mail_data.dart';

import '../db/hive_manager.dart';
import '../db/mailbox_folder.dart';
import '../db/mailbox_settings.dart';

final log = Logger('MailboxesHeader');

class MailHelper {
  Future<MailClient> tryLogin(MailboxSettings mailbox) async {
    final config = await Discover.discover(mailbox.emailAddress);
    if (config == null) {
      log.warning('Unable to auto-discover settings for $mailbox.emailAddress');
      throw BaseMailException("Unable to auto-discover settings for $mailbox.emailAddress");
    }
    log.info('connecting to ${config.displayName}.');
    final account = MailAccount.fromDiscoveredSettings('my account', mailbox.emailAddress, mailbox.password, config);
    final mailClient = MailClient(account, isLogEnabled: false);
    try {
      await mailClient.connect();
      log.info('connected');
      return mailClient;
    } on MailException catch (e) {
      log.info('High level API failed with $e');
      rethrow;
    }
  }

  List<MailboxFolder> getFoldersForMailbox(MailboxSettings mailbox) {
    //FIXME this does not need to be a future anymore
    return Hive.box<MailboxFolder>(mailboxFolderBoxName).values.toList();
  }

  //FIXME this does not need to be a future anymore
  Future<List<MimeMessage>> getFolderContent(MailboxSettings mailbox, String folder) async {
    var values = Hive.box<EmailObject>(mailObjectSettingsBoxName).values.where((element) => element.mailboxId == mailbox.emailAddress && element.folderName == folder);
    if (values.isEmpty) {
      return Future.value(Future(List<MimeMessage>.empty));
    }
    List<MimeMessage> calculated = [];
    for (var element in values) {
      var value = MimeMessage.parseFromText(element.data);
      value.guid = element.guid;
      calculated.add(value);
    }
    return Future.value(calculated.toList());
  }

  //FIXME this does not need to be a future anymore
  Future<MimeMessage> getMail(MailboxSettings mailbox, String folder, int guid) async {
    var result = Hive.box<EmailObject>(mailObjectSettingsBoxName).values.firstWhere((element) => element.key == guid);
    return Future.value(MimeMessage.parseFromText(result.data));
  }

  Future<void> sendMail(int mailboxIndex, ComposeMailData state) async {
    /*var mailbox = Hive.box<MailboxSettings>(mailboxesSettingsBoxName).getAt(mailboxIndex)!;
    var messageBuilder = MessageBuilder();
    messageBuilder.from = [];
    messageBuilder.from!.add(MailAddress("", state.fromEmail));

    for (var element in state.toEmails) {
      messageBuilder.addRecipient(MailAddress("", element), group: RecipientGroup.to);
    }
    messageBuilder.subject = state.subject;

    for (var element in state.ccEmails) {
      messageBuilder.addRecipient(MailAddress("", element), group: RecipientGroup.cc);
    }

    for (var element in state.bccEmails) {
      messageBuilder.addRecipient(MailAddress("", element), group: RecipientGroup.bcc);
    }

    //TODO maybe only add if it's html? but it's duplicated anyway?
    messageBuilder.addTextHtml(state.content);
    /*var mailclient = await login(mailbox);
    await mailclient.sendMessage(messageBuilder.buildMimeMessage());*/*/
  }
}
