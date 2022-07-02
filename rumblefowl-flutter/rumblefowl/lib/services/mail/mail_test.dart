import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

final log = Logger('MailboxesHeader');

class MailHelper with ChangeNotifier {
  late MailClient mailClient;

  late Tree<Mailbox?> mailboxes;

  isInitDone() {
    return mailClient.isConnected;
  }

  getEmailAddress() async {
    await init();
    return mailClient.account.email;
  }

  init() async {
    // authenticate
    String email = const String.fromEnvironment('EMAIL_ACCOUNT', defaultValue: 'EMAIL_ACCOUNT');
    String pw = const String.fromEnvironment('EMAIL_PW', defaultValue: 'EMAIL_PW');

    log.info('discovering settings for  $email...');
    final config = await Discover.discover(email);
    if (config == null) {
      // note that you can also directly create an account when
      // you cannot auto-discover the settings:
      // Compare the [MailAccount.fromManualSettings]
      // and [MailAccount.fromManualSettingsWithAuth]
      // methods for details.
      log.info('Unable to auto-discover settings for $email');
      return;
    }
    log.info('connecting to ${config.displayName}.');
    final account = MailAccount.fromDiscoveredSettings('my account', email, pw, config);
    final mailClient = MailClient(account, isLogEnabled: kDebugMode);
    try {
      await mailClient.connect();
      log.info('connected');
      this.mailClient = mailClient;
      mailboxes = await mailClient.listMailboxesAsTree(createIntermediate: false);

      notifyListeners();
    } on MailException catch (e) {
      log.info('High level API failed with $e');
    }
  }
}
