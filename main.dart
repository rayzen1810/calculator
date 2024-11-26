import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}
class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorUI(),
    );
  }
}
class CalculatorUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Display (ekran)
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.grey[850],
                padding: EdgeInsets.symmetric(horizontal: 36),
                alignment: Alignment.centerRight,
                child: Text(
                  "0",
                  style: TextStyle(
                    fontSize: 90,
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
            // Tugmalar
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  buildButtonRow(["AC", "+/-", "%", "÷"], Colors.grey[800]!, Colors.orange),
                  buildButtonRow(["7", "8", "9", "×"], Colors.grey[700]!, Colors.orange),
                  buildButtonRow(["4", "5", "6", "-"], Colors.grey[700]!, Colors.orange),
                  buildButtonRow(["1", "2", "3", "+"], Colors.grey[700]!, Colors.orange),
                  buildLastButtonRow(["0", ",", "="], Colors.grey[700]!, Colors.orange),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget buildButtonRow(List<String> texts, Color bgColor, Color operatorColor) {
    return Expanded(
      child: Row(
        children: texts.map((text) {
          bool isOperator = ["÷", "×", "-", "+", "="].contains(text);
          return Expanded(
            child: buildButton(
              text: text,
              bgColor: isOperator ? operatorColor : bgColor,
              textColor: Colors.white,
            ),
          );
        }).toList(),
      ),
    );
  }
  Widget buildLastButtonRow(List<String> texts, Color bgColor, Color operatorColor) {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: buildButton(
              text: texts[0],
              bgColor: bgColor,
              textColor: Colors.white,
            ),
          ),
          Expanded(
            flex: 1,
            child: buildButton(
              text: texts[1],
              bgColor: bgColor,
              textColor: Colors.white,
            ),
          ),
          Expanded(
            flex: 1,
            child: buildButton(
              text: texts[2],
              bgColor: operatorColor,
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
  Widget buildButton({
    required String text,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      margin: EdgeInsets.all(0.5), // Buttonlar orasidagi masoda margin berilgan
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(),
          padding: EdgeInsets.zero,
          elevation: 0, // Buttonlar hammasi tekkis bo'lishi uchun
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w400,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}