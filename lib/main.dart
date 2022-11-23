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
  var nums = <String>["0"];
  var numOps = 0;
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
            if (input == "0") {
              nums[nums.length - 1] = txt;
              input = txt;
            } else if (input.endsWith("+") ||
                (input.endsWith("-") &&
                    !(input.endsWith("+-") ||
                        input.endsWith("--") ||
                        input.endsWith("*-") ||
                        input.endsWith("/-"))) ||
                input.endsWith("*") ||
                input.endsWith("/")) {
              nums[nums.length - 1] = txt;
              input = "$input$txt";
            } else if (nums[nums.length - 1] == "0") {
              nums[nums.length - 1] = txt;
              input = input.substring(0, input.length - 1);
              input = "$input$txt";
            } else {
              var curr = nums[nums.length - 1];
              nums[nums.length - 1] = "$curr$txt";
              input = "$input$txt";
            }
          }
          break;
        case "±":
          if (input.length < 24) {
            if (nums[nums.length - 1].contains("-")) {
              input = input.substring(
                  0, input.length - nums[nums.length - 1].length);
              nums[nums.length - 1] = nums[nums.length - 1].substring(1);
              var curr = nums[nums.length - 1];
              input = "$input$curr";
            } else {
              var curr = nums[nums.length - 1];
              nums[nums.length - 1] = "-$curr";
              input = input.substring(0, input.length - curr.length);
              input = "$input-$curr";
            }
          }

          break;
        case ".":
          if (input.length < 24 && !nums[nums.length - 1].contains(".")) {
            var curr = nums[nums.length - 1];
            nums[nums.length - 1] = "$curr$txt";
            input = "$input$txt";
          }
          break;
        case "+":
        case "-":
        case "*":
        case "/":
          if (input.length < 24 && nums[nums.length - 1] != "") {
            numOps = numOps + 1;
            input = "$input$txt";
            nums.add("");
          }
          break;
        case "<":
          if (input.endsWith("+") ||
              (input.endsWith("-") &&
                  (!(input.endsWith("+-") ||
                          input.endsWith("--") ||
                          input.endsWith("*-") ||
                          input.endsWith("/-")) &&
                      nums.length > 1)) ||
              input.endsWith("*") ||
              input.endsWith("/")) {
            nums.removeLast();
            numOps = numOps - 1;
            input = input.substring(0, input.length - 1);
          } else {
            nums[nums.length - 1] = nums[nums.length - 1]
                .substring(0, nums[nums.length - 1].length - 1);
            input = input.substring(0, input.length - 1);
            if (input == "") {
              input = "0";
              nums[nums.length - 1] = "0";
            }
          }
          break;
        case "C":
          input = "0";
          numOps = 0;
          nums.clear();
          nums.add("0");
          break;
        case "AC":
          input = "0";
          numOps = 0;
          nums.clear();
          nums.add("0");
          history.clear();
          break;
        case "=":
          if (numOps > 0) {
            Parser p = Parser();
            Expression exp = p.parse(input);
            ContextModel cm = ContextModel();
            double eval = exp.evaluate(EvaluationType.REAL, cm);
            history.insert(0, "$input=$eval");
            input = "$eval";
            numOps = 0;
            nums.clear();
            nums.add("$eval");
          }
          break;
      }
      // print(numOps);
      // print(input);
      // for (var x in nums) {
      //   print(x);
      // }
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
