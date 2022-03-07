import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  final Function removeTx;

  TransactionList(this.transactions, this.removeTx);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: [
                SizedBox(
                  height: constraints.maxHeight * 0.02,
                ),
                Container(
                  height: constraints.maxHeight * 0.06,
                  child: FittedBox(
                    child: Text(
                      "No transactions added yet!",
                      style: TextStyle(color: Color.fromRGBO(220, 220, 220, 1)),
                    ),
                  ),
                ),
                SizedBox(
                  height: constraints.maxHeight * 0.06,
                ),
                Container(
                    height: constraints.maxHeight * 0.3,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    )),
              ],
            );
          })
        : Container(
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Color.fromRGBO(60, 60, 60, 1)),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  margin: EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: FittedBox(
                            child: Text('\$${transactions[index].amount}')),
                      ),
                    ),
                    title: Text(
                      transactions[index].title,
                      style: TextStyle(color: Color.fromRGBO(220, 220, 220, 1)),
                    ),
                    subtitle: Text(
                      DateFormat.yMMMd().format(transactions[index].date),
                      style: TextStyle(color: Color.fromRGBO(220, 220, 220, 1)),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        removeTx(transactions[index].id);
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                );
              },
              itemCount: transactions.length,
            ),
          );
  }
}
