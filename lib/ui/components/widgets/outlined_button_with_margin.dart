import 'package:flutter/material.dart';
import 'package:rumblefowl/ui/components/widgets/utils.dart';

///Button with margins
class OutlinedButtonWithMargin extends StatelessWidget {
  const OutlinedButtonWithMargin({Key? key, required this.onPressedAction, required this.buttonText, this.isHighlighted = false}) : super(key: key);

  final EdgeInsets margins = const EdgeInsets.all(8.0);
  final OnPressedAction onPressedAction;
  final String buttonText;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
          margin: margins,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                onPrimary: Theme.of(context).colorScheme.onPrimary,
                primary: Theme.of(context).colorScheme.primary,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                )),
            onPressed: onPressedAction,
            child: Text(buttonText),
          )),
    ]);
  }
}
