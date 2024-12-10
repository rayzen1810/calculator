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

class CalculatorLogic {
  String _displayValue = '0';
  String _operator = '';
  double? _firstOperand;
  bool _isOperatorPressed = false;
  bool _resultDisplayed = false;

  String get displayValue => _displayValue;

  void input(String userInput) {
    if (userInput == 'AC') {
      _clear();
      return;
    }

    if (_resultDisplayed) {
      if (['+', '-', '×', '÷'].contains(userInput)) {
        _operator = userInput;
        _firstOperand = double.tryParse(_displayValue);
        _isOperatorPressed = true;
        _resultDisplayed = false;
      } else {
        _clear();
        input(userInput);
      }
      return;
    }

    if (userInput == '+/-') {
      if (_displayValue != '0') {
        _displayValue = _displayValue.startsWith('-')
            ? _displayValue.substring(1)
            : '-$_displayValue';
      }
      return;
    }

    if (userInput == '%') {
      if (_firstOperand != null && _operator.isNotEmpty) {
        double secondOperand = double.tryParse(_displayValue) ?? 0.0;
        _displayValue = (_firstOperand! * secondOperand / 100).toString();
      } else {
        double currentValue = double.tryParse(_displayValue) ?? 0.0;
        _displayValue = (currentValue / 100).toString();
      }
      if (_displayValue.endsWith('.0')) {
        _displayValue = _displayValue.substring(0, _displayValue.length - 2);
      }
      return;
    }

    if (['+', '-', '×', '÷'].contains(userInput)) {
      if (!_isOperatorPressed) {
        _operator = userInput;
        _firstOperand = double.tryParse(_displayValue);
        _isOperatorPressed = true;
      } else {
        _operator = userInput;
      }
      return;
    }

    if (userInput == '=') {
      double? secondOperand = double.tryParse(_displayValue);
      if (_firstOperand != null && secondOperand != null) {
        _calculate(secondOperand);
      }
      _isOperatorPressed = false;
      _resultDisplayed = true;
      return;
    }

    if (_isOperatorPressed) {
      _displayValue = userInput == ',' ? '0.' : userInput;
      _isOperatorPressed = false;
    } else {
      if (userInput == ',') {
        if (!_displayValue.contains('.')) {
          _displayValue += '.';
        }
      } else {
        _displayValue =
            _displayValue == '0' ? userInput : _displayValue + userInput;
      }
    }
  }

  void _calculate(double secondOperand) {
    double result = 0.0;

    switch (_operator) {
      case '+':
        result = _firstOperand! + secondOperand;
        break;
      case '-':
        result = _firstOperand! - secondOperand;
        break;
      case '×':
        result = _firstOperand! * secondOperand;
        break;
      case '÷':
        if (secondOperand != 0) {
          result = _firstOperand! / secondOperand;
        } else {
          _displayValue = 'Error';
          return;
        }
        break;
    }

    _displayValue = result.toStringAsFixed(12);
    _displayValue = _displayValue.replaceAll(RegExp(r'0+$'), '');
    if (_displayValue.endsWith('.')) {
      _displayValue = _displayValue.substring(0, _displayValue.length - 1);
    }

    _firstOperand = null;
    _operator = '';
  }

  void _clear() {
    _displayValue = '0';
    _firstOperand = null;
    _operator = '';
    _isOperatorPressed = false;
    _resultDisplayed = false;
  }
}

class CalculatorUI extends StatefulWidget {
  @override
  _CalculatorUIState createState() => _CalculatorUIState();
}

class _CalculatorUIState extends State<CalculatorUI> {
  final CalculatorLogic _logic = CalculatorLogic();

  void _onButtonPressed(String input) {
    setState(() {
      _logic.input(input);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Displey
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.grey[850],
                padding: EdgeInsets.symmetric(horizontal: 36),
                alignment: Alignment.centerRight,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    _logic.displayValue,
                    style: TextStyle(
                      fontSize: 90,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            // Tugmalar
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  buildButtonRow(["AC", "+/-", "%", "÷"], Colors.grey[800]!,
                      Colors.orange),
                  buildButtonRow(
                      ["7", "8", "9", "×"], Colors.grey[700]!, Colors.orange),
                  buildButtonRow(
                      ["4", "5", "6", "-"], Colors.grey[700]!, Colors.orange),
                  buildButtonRow(
                      ["1", "2", "3", "+"], Colors.grey[700]!, Colors.orange),
                  buildLastButtonRow(
                      ["0", ",", "="], Colors.grey[700]!, Colors.orange),
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
      margin: EdgeInsets.all(0.5),
      child: ElevatedButton(
        onPressed: () => _onButtonPressed(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(),
          padding: EdgeInsets.zero,
          elevation: 0,
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
