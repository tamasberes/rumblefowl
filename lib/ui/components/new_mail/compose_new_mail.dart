import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:logging/logging.dart';
import 'package:notustohtml/notustohtml.dart';
import 'package:provider/provider.dart';
import 'package:rumblefowl/services/db/hive_manager.dart';
import 'package:rumblefowl/services/mail/mail_helper.dart';
import 'package:rumblefowl/services/prerferences/preferences_manager.dart';
import 'package:zefyrka/zefyrka.dart';

import '../../../services/db/mailbox_settings.dart';
import '../../util/scrollcontroller.dart';
import '../widgets/elevated_button_with_margin.dart';
import '../widgets/utils.dart';
import 'compose_mail_data.dart';
import 'email_list_notifier.dart';

final log = Logger('ComposeNewMailWindow');
const inputItemWidth = 223.0;

class ComposeNewMailWindow extends StatefulWidget {
  const ComposeNewMailWindow({Key? key}) : super(key: key);

  @override
  State<ComposeNewMailWindow> createState() => _ComposeNewMailWindowState();
}

class _ComposeNewMailWindowState extends State<ComposeNewMailWindow> {
  final state = ComposeMailData("", [], "", [], [], "", "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Compose new E-mail")),
      body: Column(children: <Widget>[
        Row(
          children: [
            getFrom(),
            getActionButtons(),
          ],
        ),
        getTextInputWithChips("To", state.toEmails),
        getReplyToAddress(),
        getTextInputWithChips("CC", state.ccEmails),
        getTextInputWithChips("BCC", state.bccEmails),
        getSubject(),
        Container(height: spacingBetweenItemsVertical),
        Expanded(child: Row(children: [Expanded(child: getWysiwygEditor())]))
      ]),
    );
  }

  indexChanged(int value) {
    log.info("index changed in parent:$value");
  }

  int getCurrentIndex() {
    return 0;
  }

  var dropdownValue = Hive.box<MailboxSettings>(mailboxesSettingsBoxName).values.elementAt(PreferencesManager().getSelectedMailbox()).emailAddress;

  Widget getFrom() {
    var values = Hive.box<MailboxSettings>(mailboxesSettingsBoxName).values;
    //use mailbox selected by user
    final leadingStyle = Theme.of(context).textTheme.labelLarge!;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        createLeadingLabel("From:", leadingStyle),
        DropdownButton<String>(
          value: dropdownValue,
          icon: const Icon(Icons.expand_more),
          elevation: 16,
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String? newValue) {
            setState(() {
              log.info(newValue);
              dropdownValue = newValue!;
              state.fromEmail = newValue;
            });
          },
          items: values.map<DropdownMenuItem<String>>((value) {
            return DropdownMenuItem<String>(
              value: value.emailAddress,
              child: Text(value.emailAddress),
            );
          }).toList(),
        ),
      ],
    );
  }

  //       MailboxSettings currentItem = box.getAt(index)!;
  Widget getReplyToAddress() {
    final leadingStyle = Theme.of(context).textTheme.labelLarge!;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        createLeadingLabel("Reply to:", leadingStyle),
        SizedBox(
          width: inputItemWidth,
          child: TextField(
            onChanged: (text) {
              state.replyTo = text;
            },
          ),
        )
      ],
    );
  }

  Widget createLeadingLabel(String labelText, TextStyle style) {
    return SizedBox(
        width: 90,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
            child: Text(
              labelText,
              style: style,
              textAlign: TextAlign.end,
            )));
  }

  Widget getTextInputWithChips(String label, List<String> list) {
    final leadingStyle = Theme.of(context).textTheme.labelLarge!;
    final fieldText = TextEditingController();
    final FocusNode myFocusNode = FocusNode();

    return ChangeNotifierProvider(
        create: (_) => EmailListNotifier(),
        builder: (context, child) {
          return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            createLeadingLabel(label, leadingStyle),
            SizedBox(
              width: inputItemWidth,
              child: TextField(
                focusNode: myFocusNode,
                controller: fieldText,
                onSubmitted: (value) {
                  //value is entered text after ENTER press
                  //you can also call any function here or make setState() to assign value to other variable
                  log.info("to input done:$value");
                  Provider.of<EmailListNotifier>(context, listen: false).add(value);
                  fieldText.clear();
                  myFocusNode.requestFocus();
                  list.add(value);
                },
                textInputAction: TextInputAction.search,
              ),
            ),
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                    //had to set height in advance, lazy listview size would be 0 at start
                    minHeight: 48.0,
                    minWidth: 400,
                    maxHeight: 48.0),
                child: Container(
                  margin: const EdgeInsets.fromLTRB(spacingBetweenItemsVertical, 0, 0, 0),
                  // color: Colors.red,
                  child: ListView.builder(
                      shrinkWrap: true,
                      controller: AdjustableScrollController(),
                      scrollDirection: Axis.horizontal,
                      itemCount: Provider.of<EmailListNotifier>(context, listen: true).get().length,
                      itemBuilder: (context, index) {
                        String currentItem = Provider.of<EmailListNotifier>(context, listen: true).get().elementAt(index);
                        return ElevatedButtonWithMargin(
                            //isHighlighted: selectedIndex == index,
                            buttonText: currentItem,
                            onPressedAction: () {
                              log.info("mailbox clicked$currentItem");

                              setState(() {
                                //selectedIndex = index;
                              });
                            });
                      }),
                ),
              ),
            ),
          ]);
        });
  }

  Widget getSubject() {
    final leadingStyle = Theme.of(context).textTheme.labelLarge!;
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      createLeadingLabel("Subject:", leadingStyle),
      SizedBox(
        width: inputItemWidth,
        child: TextField(
          keyboardType: TextInputType.emailAddress,
          obscureText: false,
          onChanged: (text) {
            state.subject = text;
          },
        ),
      )
    ]);
  }

  final converter = const NotusHtmlCodec();
  getWysiwygEditor() {
    ZefyrController controller = ZefyrController();
    controller.addListener(() {
        String html = const NotusHtmlCodec().encoder.convert(controller.document.toDelta());

      state.content = converter.encoder(controller.document.toDelta());
    });
    return Container(
      color: Colors.grey.shade800,
      child: Column(
        children: [
          ZefyrToolbar.basic(controller: controller),
          Expanded(
            child: ZefyrEditor(
              padding: const EdgeInsets.only(left: 16, right: 16),
              controller: controller,
            ),
          ),
        ],
      ),
    );
  }

  getActionButtons() {
    final rectangleStyle = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 8.0),
      child: Wrap(
        spacing: 8,
        children: [
          ElevatedButton.icon(
            style: rectangleStyle,
            label: const Icon(Icons.send),
            icon: const Text('Send'),
            onPressed: () {
              onSendClicked();
            },
          ),
          ElevatedButton.icon(
            style: rectangleStyle,
            icon: const Text('Forward'),
            label: const Icon(Icons.forward_to_inbox),
            onPressed: () => {log.info("Forward clicked")},
          ),
          ElevatedButton.icon(
            style: rectangleStyle,
            icon: const Text('Delete'),
            label: const Icon(Icons.delete_forever),
            onPressed: () => {log.info("Delete clicked")},
          ),
        ],
      ),
    );
  }

  //gathers filled out values, composes an email and send it
  onSendClicked() async {
    log.info("onSendClicked:${jsonEncode(state)}");

    await MailHelper().sendMail(PreferencesManager().getSelectedMailbox(), state);

    log.info("email sent");

  }
}

@immutable
class User {
  const User({
    required this.email,
    required this.name,
  });

  final String email;
  final String name;

  @override
  String toString() {
    return '$name, $email';
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is User && other.name == name && other.email == email;
  }

  @override
  int get hashCode => Object.hash(email, name);
}

class AutocompleteBasicUserExample extends StatelessWidget {
  const AutocompleteBasicUserExample({Key? key}) : super(key: key);

  static const List<User> _userOptions = <User>[
    User(name: 'Alice', email: 'alice@example.com'),
    User(name: 'Bob', email: 'bob@example.com'),
    User(name: 'Charlie', email: 'charlie123@gmail.com'),
  ];

  static String _displayStringForOption(User option) => option.name;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: inputItemWidth,
      child: Autocomplete<User>(
        displayStringForOption: _displayStringForOption,
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '') {
            return const Iterable<User>.empty();
          }
          return _userOptions.where((User option) {
            return option.toString().contains(textEditingValue.text.toLowerCase());
          });
        },
        onSelected: (User selection) {
          log.info('You just selected ${_displayStringForOption(selection)}');
        },
      ),
    );
  }
}
