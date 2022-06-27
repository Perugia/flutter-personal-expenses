import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;
  Chart(this.recentTransactions) {
    print("Constuctor Chart");
  }

  List<Map> get groupTransactionValues {
    return List.generate(7, (index) {
      DateTime now = DateTime.now();
      final firstDayWeek =
          DateTime(now.year, now.month, now.day + (7 - now.weekday));
      final weekDay = firstDayWeek.subtract(Duration(days: index));
      var totalSum = 0.0;

      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }

      return {
        'amount': double.parse(totalSum.toStringAsFixed(2)),
        'day': DateFormat.E().format(weekDay).substring(0, 1),
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupTransactionValues.fold(0.0, (sum, item) {
      return sum + item["amount"];
    });
  }

  @override
  Widget build(BuildContext context) {
    print("build Chart");
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Color.fromRGBO(60, 60, 60, 1)),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
      margin: const EdgeInsets.only(bottom: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: groupTransactionValues.map((data) {
          return Flexible(
            fit: FlexFit.tight,
            child: ChartBar(
              data['day'],
              data['amount'],
              totalSpending == 0.0
                  ? 0.0
                  : (data['amount'] as double) / totalSpending,
            ),
          );
          // return Text('${data['day']}:${data['amount']} ');
        }).toList(),
      ),
    );
  }
}
