import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:zefyrka/zefyrka.dart';

import '../widgets/utils.dart';

final log = Logger('ComposeNewMailWindow');

class ComposeNewMailWindow extends StatefulWidget {
  const ComposeNewMailWindow({Key? key}) : super(key: key);

  @override
  State<ComposeNewMailWindow> createState() => _ComposeNewMailWindowState();
}

class _ComposeNewMailWindowState extends State<ComposeNewMailWindow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Compose new E-mail")),
        body: Padding(
          padding: const EdgeInsets.all(paddingWidgetEdges),
          child: Expanded(
            child: Column(children: <Widget>[getFrom(), getTo(), getCC(), getBCC(), getSubject(), getWysiwygEditor()]),
          ),
        ));
  }

  indexChanged(int value) {
    log.info("index changed in parent:$value");
  }

  int getCurrentIndex() {
    return 0;
  }

  String dropdownValue = 'example@example.com';

  Widget getFrom() {
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
              dropdownValue = newValue!;
            });
          },
          items: <String>['example@example.com', 'example@example.com2', 'example@example.com3', 'example@example.com4'].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget createLeadingLabel(String labelText, TextStyle style) {
    return SizedBox(width: 60, child: Padding(padding: const EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0), child: Text(labelText, style: style)));
  }

  Widget getTo() {
    final leadingStyle = Theme.of(context).textTheme.labelLarge!;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [createLeadingLabel("To:", leadingStyle), const AutocompleteBasicUserExample()],
    );
  }

  Widget getCC() {
    final leadingStyle = Theme.of(context).textTheme.labelLarge!;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [createLeadingLabel("CC:", leadingStyle), const AutocompleteBasicUserExample()],
    );
  }

  Widget getBCC() {
    final leadingStyle = Theme.of(context).textTheme.labelLarge!;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [createLeadingLabel("BCC:", leadingStyle), const AutocompleteBasicUserExample()],
    );
  }

  Widget getSubject() {
    final leadingStyle = Theme.of(context).textTheme.labelLarge!;
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      createLeadingLabel("Subject:", leadingStyle),
      const SizedBox(
        width: 210,
        child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Subject',
            )),
      )
    ]);
  }

  getWysiwygEditor() {
    ZefyrController _controller = ZefyrController();
    
    return Container(color: Colors.grey.shade700,
      child: SizedBox(height: 500,
        child: Column(
          children: [
            ZefyrToolbar.basic(controller: _controller),
            Expanded(
              child: ZefyrEditor(
                padding: EdgeInsets.only(left: 16, right: 16),
                controller: _controller,
              ),
            ),
          ],
        ),
      ),
    );
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
      width: 210,
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
          debugPrint('You just selected ${_displayStringForOption(selection)}');
        },
      ),
    );
  }
}
