
import 'package:flutter/material.dart';

///Button with margins
class ElevatedButtonWithMargin extends StatelessWidget {
  const ElevatedButtonWithMargin({Key? key, required this.onPressedAction, required this.buttonText}) : super(key: key);

  final EdgeInsets margins = const EdgeInsets.all(8.0);
  final OnPressedAction onPressedAction;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
          margin: margins,
          child: ElevatedButton(
            onPressed: onPressedAction,
            child: Text(buttonText),
          )),
    ]);
  }
}

typedef OnPressedAction = void Function();

