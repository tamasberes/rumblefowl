import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import '../db/mailbox_settings.dart';

final log = Logger('MailboxesHeader');

class MailHelper {
  Future<void> trySettings(MailboxSettings selectedMailbox) async {
    final config = await Discover.discover(selectedMailbox.emailAddress);
    if (config == null) {
      // note that you can also directly create an account when
      // you cannot auto-discover the settings:
      // Compare the [MailAccount.fromManualSettings]
      // and [MailAccount.fromManualSettingsWithAuth]
      // methods for details.
      log.warning('Unable to auto-discover settings for $selectedMailbox.emailAddress');
      throw BaseMailException("Unable to auto-discover settings for $selectedMailbox.emailAddress");
    }
    log.info('connecting to ${config.displayName}.');
    final account = MailAccount.fromDiscoveredSettings('my account', selectedMailbox.emailAddress, selectedMailbox.password, config);
    final mailClient = MailClient(account, isLogEnabled: kDebugMode);
    try {
      await mailClient.connect();
      log.info('connected');
      return;
    } on MailException catch (e) {
      log.info('High level API failed with $e');
      rethrow;
    }
  }
}
