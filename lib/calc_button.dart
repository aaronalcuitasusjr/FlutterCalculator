import 'package:flutter/material.dart';

class CalcButton extends StatelessWidget {
  const CalcButton({super.key, required this.text, required this.onPressed});

  final String text;
  final Function onPressed;

  Color bgcPicker(String txt) {
    final List<String> operators = ["/", "*", "-", "+", "="];
    final List<String> deleters = ["AC", "C", "<"];
    if (operators.contains(txt)) {
      return Colors.orange;
    }
    if (deleters.contains(txt)) {
      return Colors.pink;
    }
    return Colors.lightBlue;
  }

  Widget textPicker(String txt) {
    final List<String> enlarged = ["±", "*", "=", "-", "+"];
    if (txt == "<") {
      return Icon(Icons.backspace_outlined);
    }
    if (enlarged.contains(txt)) {
      return Text(
        text,
        style: TextStyle(
          fontFamily: 'RobotoMono',
          fontWeight: FontWeight.w400,
          fontSize: 32,
          color: Colors.white,
        ),
      );
    }
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'RobotoMono',
        fontWeight: FontWeight.w600,
        fontSize: 24,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPressed(text);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: bgcPicker(text),
      ),
      child: textPicker(text),
    );
  }
}
