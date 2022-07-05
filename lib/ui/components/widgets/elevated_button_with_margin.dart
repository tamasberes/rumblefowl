import 'package:flutter/material.dart';
import 'package:rumblefowl/ui/components/widgets/utils.dart';

///Button with margins
class ElevatedButtonWithMargin extends StatelessWidget {
  const ElevatedButtonWithMargin({Key? key, required this.onPressedAction, required this.buttonText, this.isHighlighted = false}) : super(key: key);

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
            style: isHighlighted
                ? ElevatedButton.styleFrom(
                    primary: Colors.amber, // background (button) color
                    onPrimary: Colors.black, // foreground (text) color
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ))
                : ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  )),
            onPressed: onPressedAction,
            child: Text(buttonText),
          )),
    ]);
  }
}
