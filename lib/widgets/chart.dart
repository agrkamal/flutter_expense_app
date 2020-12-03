import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './chart_bar.dart';
import '../providers/transaction.dart';
import '../const.dart';

class Chart extends StatefulWidget {
  Chart(this.transactions);

  final List<Transaction> transactions;

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  List<Map<String, Object>> get allTransactionValue {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      var totalSum = 0.0;

      for (var i = 0; i < widget.transactions.length; i++) {
        if (widget.transactions[i].date.day == weekDay.day &&
            widget.transactions[i].date.month == weekDay.month &&
            widget.transactions[i].date.year == weekDay.year) {
          totalSum += widget.transactions[i].amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 3),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double get totalAmount {
    return allTransactionValue.fold(0.0, (sum, item) {
      return sum += item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
        margin: EdgeInsets.all(8),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: kPrimaryColor,
          ),
          color: kAccentColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: allTransactionValue.map((data) {
                return Flexible(
                  fit: FlexFit.loose,
                  child: ChartBar(
                    data['day'],
                    data['amount'],
                    totalAmount == 0.0
                        ? 0.0
                        : (data['amount'] as double) / totalAmount,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
