import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import '../../services/db/hive_manager.dart';
import '../../services/db/mailbox_settings.dart';
import '../../services/mail/mail_helper.dart';
import '../../services/prerferences/preferences_manager.dart';
import 'package:webview_windows/webview_windows.dart';
import 'package:flutter/services.dart';
import 'dart:async';

final log = Logger('MailView');

final navigatorKey = GlobalKey<NavigatorState>();

class MailView extends StatefulWidget {
  const MailView({
    Key? key,
  }) : super(key: key);

  @override
  State<MailView> createState() => _MailViewState();
}

class _MailViewState extends State<MailView> {
  int selectedIndex = 0;
  final _controller = WebviewController();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    // Optionally initialize the webview environment using
    // a custom user data directory
    // and/or a custom browser executable directory
    // and/or custom chromium command line flags
    //await WebviewController.initializeEnvironment(
    //   additionalArguments: '--show-fps-counter');

    try {
      await _controller.initialize();
      await _controller.setBackgroundColor(Colors.white);
      await _controller.setPopupWindowPolicy(WebviewPopupWindowPolicy.deny);
      //await _controller.loadUrl('https://flutter.dev');

      if (!mounted) return;
      setState(() {});
    } on PlatformException catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: const Text('Error'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Code: ${e.code}'),
                      Text('Message: ${e.message}'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      child: const Text('Continue'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
      });
    }
  }

  Widget compositeView() {
    if (!_controller.value.isInitialized) {
      return const Text(
        'Not Initialized',
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return Expanded(
          child: Webview(
        _controller,
        permissionRequested: _onPermissionRequested,
      ));
    }
  }

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
                  _controller.loadStringContent(snapshot.data!.decodeTextHtmlPart()!);
                  return Column(children: [
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("From:"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(snapshot.data!.fromEmail!),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("To:"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: drawToMails(snapshot),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
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
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Date:"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(snapshot.data!.decodeDate()!.toString()),
                        )
                      ],
                    ),
                    compositeView()
                  ]);
                })));
  }

  Text drawToMails(AsyncSnapshot<MimeMessage> snapshot) {
    return Text(formatToMails(snapshot.data!.to)); //TODO this should be a listview
  }

  String formatToMails(List<MailAddress>? to) {
    if (to == null) {
      return "";
    }
    var result = "";
    for (int i = 0; i < to.length; i++) {
      var element = to[i];
      result += element.email;
      if (i < to.length - 1) {
        result += ", ";
      }
    }
    return result;
  }

  Future<WebviewPermissionDecision> _onPermissionRequested(String url, WebviewPermissionKind kind, bool isUserInitiated) async {
    final decision = await showDialog<WebviewPermissionDecision>(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('WebView permission requested'),
        content: Text('WebView has requested permission \'$kind\''),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, WebviewPermissionDecision.deny),
            child: const Text('Deny'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, WebviewPermissionDecision.allow),
            child: const Text('Allow'),
          ),
        ],
      ),
    );

    return decision ?? WebviewPermissionDecision.none;
  }
}
