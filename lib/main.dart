import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:flutter_calculator/calc_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.grey),
      ),
      home: Calculator(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  var input = "0";
  var currNum = "0";
  var currOp = "";
  var history = <String>[];

  final List<String> buttons = [
    "AC",
    "C",
    "<",
    "/",
    "7",
    "8",
    "9",
    "*",
    "4",
    "5",
    "6",
    "-",
    "1",
    "2",
    "3",
    "+",
    "±",
    "0",
    ".",
    "="
  ];

  String getAnswer(String nOne, String op, String nTwo) {
    var answer = "0";
    switch (op) {
      case "+":
        answer = "${double.parse(nOne) + double.parse(nTwo)}";
        break;
      case "-":
        answer = "${double.parse(nOne) - double.parse(nTwo)}";
        break;
      case "*":
        answer = "${double.parse(nOne) * double.parse(nTwo)}";
        break;
      case "/":
        answer = "${double.parse(nOne) / double.parse(nTwo)}";
        break;
    }
    return answer.endsWith(".0")
        ? answer.substring(0, answer.length - 2)
        : answer;
  }

  void handlePressed(String txt) {
    setState(() {
      switch (txt) {
        case "0":
        case "1":
        case "2":
        case "3":
        case "4":
        case "5":
        case "6":
        case "7":
        case "8":
        case "9":
          if (input.length < 24) {
            if (input == "0" && currNum == "0") {
              input = txt;
              currNum = txt;
            } else if (currNum == "0") {
              currNum = txt;
              input = input.substring(0, input.length - 1);
              input = "$input$currNum";
              currOp = "";
            } else if (currNum == "-0") {
              currNum = "-$txt";
              input = input.substring(0, input.length - 2);
              input = "$input$currNum";
              currOp = "";
            } else if (currNum != "0") {
              currNum = "$currNum$txt";
              input = "$input$txt";
            }
          }
          break;
        case "±":
          if (!currNum.contains("-")) {
            input = input.substring(0, input.length - currNum.length);
            currNum = "-$currNum";
            input = "$input$currNum";
          } else {
            input = input.substring(0, input.length - currNum.length);
            currNum = currNum.substring(1);
            input = "$input$currNum";
          }
          break;
        case ".":
          if (input.length < 24 && !currNum.contains(".")) {
            currNum = "$currNum$txt";
            input = "$input$txt";
          }
          break;
        case "+":
        case "-":
        case "*":
        case "/":
          if (input.length < 23 && currOp == "") {
            currOp = txt;
            currNum = "0";
            input = "$input$currOp$currNum";
            currOp = "";
          }
          break;
        case "<":
          if (input.endsWith("+-0") ||
              input.endsWith("--0") ||
              input.endsWith("*-0") ||
              input.endsWith("/-0")) {
            input = input.substring(0, input.length - currNum.length);
            currNum = "0";
            input = "$input$currNum";
          } else if (input.endsWith("+0") ||
              input.endsWith("-0") ||
              input.endsWith("*0") ||
              input.endsWith("/0")) {
            input = input.substring(0, input.length - 2);
            var index = -1;
            for (int i = input.length - 1; i > 0; i--) {
              if ((input[i] == "+" ||
                      input[i] == "-" ||
                      input[i] == "*" ||
                      input[i] == "/") &&
                  !(input[i - 1] == "+" ||
                      input[i - 1] == "-" ||
                      input[i - 1] == "*" ||
                      input[i - 1] == "/")) {
                index = i;
                break;
              }
            }
            currNum = input.substring(index + 1);
          } else if (input.length > 2) {
            if (input[input.length - 2] == "+" ||
                input[input.length - 2] == "-" ||
                input[input.length - 2] == "*" ||
                input[input.length - 2] == "/") {
              if (currNum.startsWith("-")) {
                input = input.substring(0, input.length - 2);
                currNum = "-0";
              } else {
                input = input.substring(0, input.length - 1);
                currNum = "0";
              }
              input = "$input$currNum";
            } else if (input != "" && currNum != "") {
              input = input.substring(0, input.length - 1);
              currNum = currNum.substring(0, currNum.length - 1);
            }
          } else if (input != "" && currNum != "") {
            input = input.substring(0, input.length - 1);
            currNum = currNum.substring(0, currNum.length - 1);
            if (input == "") {
              input = "0";
              currNum = "0";
            }
          }
          break;
        case "C":
          input = "0";
          currNum = "0";
          currOp = "";
          break;
        case "AC":
          input = "0";
          currNum = "0";
          currOp = "";
          history.clear();
          break;
        case "=":
          if (input.substring(1).contains("+") ||
              input.substring(1).contains("-") ||
              input.substring(1).contains("*") ||
              input.substring(1).contains("/")) {
            Parser p = Parser();
            Expression exp = p.parse(input);
            ContextModel cm = ContextModel();
            double eval = exp.evaluate(EvaluationType.REAL, cm);
            history.insert(0, "$input=$eval");
            input = "$eval";
            currNum = "$eval";
            currOp = "";
          }

          break;
      }
    });
  }

  List<Widget> getItems() {
    final List<Widget> historyItems = <Widget>[];
    for (var item in history) {
      historyItems.add(Text(
        item,
        textAlign: TextAlign.right,
        style: TextStyle(
          fontFamily: 'RobotoMono',
          fontWeight: FontWeight.w400,
          fontSize: 18,
          color: Colors.grey,
        ),
      ));
    }
    return historyItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Container(
                color: Colors.black,
                padding: EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        reverse: true,
                        children: getItems(),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          input,
                          textAlign: TextAlign.end,
                          maxLines: 2,
                          style: TextStyle(
                            fontFamily: 'RobotoMono',
                            fontWeight: FontWeight.w600,
                            fontSize: 48,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Wrap(
              children: [
                Container(
                  color: Colors.black,
                  child: GridView.count(
                    primary: false,
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    padding: EdgeInsets.all(12),
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: buttons
                        .map((button) => CalcButton(
                              text: button,
                              onPressed: handlePressed,
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
