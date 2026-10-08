import 'package:flutter/material.dart';

import 'dart:math';

void main() {
  runApp(Calculator());
}

class Calculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Calc());
  }
}

class Calc extends StatefulWidget {
  @override
  State<Calc> createState() => _CalcState();
}

class _CalcState extends State<Calc> {
  String s = '';
  String r = '0';
  String h = '';

  String p(String t) {
    List mas = [];
    String x = '';
    for (int i = 0; i < t.length; i++) {
      String c = t[i];
      if ('+-×÷^'.contains(c) && x != '') {
        double? a = double.tryParse(x);
        if (a == null) return 'Ошибка';
        mas.add(a);
        mas.add(c);
        x = '';
      } else {
        x = x + c;
      }
    }
    double? a = double.tryParse(x);
    if (a == null) return 'Ошибка';
    mas.add(a);

    int j = 1;
    while (j < mas.length) {
      if (mas[j] == '^') {
        double a = mas[j - 1];
        double b = mas[j + 1];
        mas[j - 1] = pow(a, b).toDouble();
        mas.removeAt(j);
        mas.removeAt(j);
      } else {
        j = j + 2;
      }
    }

    int i = 1;
    while (i < mas.length) {
      if (mas[i] == '×' || mas[i] == '÷') {
        double a = mas[i - 1];
        double b = mas[i + 1];
        double c = 0;
        if (mas[i] == '×') {
          c = a * b;
        } else {
          if (b == 0) return 'Ошибка';
          c = a / b;
        }
        mas[i - 1] = c;
        mas.removeAt(i);
        mas.removeAt(i);
      } else {
        i = i + 2;
      }
    }

    double g = mas[0];
    for (int i = 1; i < mas.length; i = i + 2) {
      if (mas[i] == '+') {
        g = g + mas[i + 1];
      } else {
        g = g - mas[i + 1];
      }
    }

    if (g.isNaN || g.isInfinite || g.abs() > 1e15) return 'Ошибка';

    String o = g.toStringAsFixed(6);
    while (o.endsWith('0')) {
      o = o.substring(0, o.length - 1);
    }
    if (o.endsWith('.')) o = o.substring(0, o.length - 1);
    if (o == '-0') o = '0';
    return o;
  }

  void n(String k) {
    setState(() {
      if (k == 'C') {
        s = '';
        r = '0';
        h = '';
      } else if (k == '<') {
        if (s != '') s = s.substring(0, s.length - 1);
      } else if (k == '=') {
        if (s != '') {
          h = s + ' =';
          r = p(s);
          s = '';
        }
      } else if ('+-×÷^'.contains(k)) {
        if (s == '') {
          if (r == 'Ошибка') return;
          s = r;
        }
        String l = s[s.length - 1];
        if ('+-×÷^'.contains(l)) s = s.substring(0, s.length - 1);
        s = s + k;
      } else {
        if (s == '') h = '';
        s = s + k;
      }
    });
  }

  Widget b(String k) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(4),
        child: SizedBox(
          height: 70,
          child: ElevatedButton(
            onPressed: () => n(k),
            child: Text(k, style: TextStyle(fontSize: 26)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Калькулятор')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(h, style: TextStyle(fontSize: 22, color: Colors.grey)),
                  Text(s == '' ? r : s, style: TextStyle(fontSize: 44)),
                ],
              ),
            ),
          ),
          Row(children: [b('C'), b('<'), b('÷'), b('×')]),
          Row(children: [b('7'), b('8'), b('9'), b('-')]),
          Row(children: [b('4'), b('5'), b('6'), b('+')]),
          Row(children: [b('1'), b('2'), b('3'), b('.')]),
          Row(children: [b('0'), b('^'), b('=')]),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
