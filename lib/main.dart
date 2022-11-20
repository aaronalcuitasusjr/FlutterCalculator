import 'package:flutter/material.dart';
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
  var numOne = "0";
  var numTwo = "";
  var operator = "";
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
            if (operator != "" && numTwo == "0") {
              numTwo = txt;
              input = "$numOne$operator$numTwo";
            } else if (operator != "") {
              input = "$input$txt";
              numTwo = "$numTwo$txt";
            } else if (numOne != "0" && operator == "") {
              input = "$input$txt";
              numOne = "$numOne$txt";
            } else if (numOne == "0" && operator == "") {
              input = txt;
              numOne = txt;
            }
          }
          break;
        case "±":
          if ((numOne != "" && operator != "") &&
              (numTwo != "" && !numTwo.startsWith("-"))) {
            if (input.length < 24) {
              numTwo = "-$numTwo";
              input = "$numOne$operator$numTwo";
            }
          } else if ((numOne != "" && operator != "") && numTwo != "") {
            numTwo = numTwo.substring(1);
            input = "$numOne$operator$numTwo";
          } else if ((numOne != "" && operator == "") &&
              !numOne.startsWith("-")) {
            if (input.length < 24) {
              numOne = "-$numOne";
              input = numOne;
            }
          } else if ((numOne != "" && operator == "")) {
            numOne = numOne.substring(1);
            input = numOne;
          }
          break;
        case ".":
          if ((operator == "" && numTwo == "") &&
              (!numOne.contains(".") && input.length < 24)) {
            input = "$input$txt";
            numOne = "$numOne$txt";
          } else if ((operator != "" && numTwo == "") && input.length < 23) {
            input = "${input}0$txt";
            numTwo = "0$txt";
          } else if ((operator != "" && !numTwo.contains(".")) &&
              (numTwo != "" && input.length < 24)) {
            input = "$input$txt";
            numTwo = "$numTwo$txt";
          }
          break;
        case "+":
        case "-":
        case "*":
        case "/":
          if ((operator == "" && !numOne.endsWith(".")) && input.length < 24) {
            input = "$input$txt";
            operator = txt;
          }
          break;
        case "<":
          if ((numOne != "" && operator != "") && numTwo != "") {
            input = input.substring(0, input.length - 1);
            numTwo = numTwo.substring(0, numTwo.length - 1);
          } else if (numOne != "" && operator != "") {
            input = input.substring(0, input.length - 1);
            operator = "";
          } else if (numOne != "") {
            input = input.substring(0, input.length - 1);
            numOne = numOne.substring(0, numOne.length - 1);
            if (numOne == "") {
              input = "0";
              numOne = "0";
            }
          }
          break;
        case "C":
          input = "0";
          numOne = "0";
          numTwo = "";
          operator = "";
          break;
        case "AC":
          input = "0";
          numOne = "0";
          numTwo = "";
          operator = "";
          history.clear();
          break;
        case "=":
          if ((numOne != "" && operator != "") &&
              (numTwo != "" && !numTwo.endsWith("."))) {
            var answer = getAnswer(numOne, operator, numTwo);
            history.insert(0, "$numOne $operator $numTwo = $answer");
            numOne = answer;
            input = answer;
            numTwo = "";
            operator = "";
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
