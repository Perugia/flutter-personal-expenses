import 'package:flutter/material.dart';
import '../models/transaction.dart';
import './transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  final Function removeTx;

  TransactionList(this.transactions, this.removeTx);

  @override
  Widget build(BuildContext context) {
    print("build transactionList");
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
            child: ListView(
              children: transactions
                  .map(
                    (tx) => TransactionItem(
                      key: ValueKey(tx.id),
                      transaction: tx,
                      removeTx: removeTx,
                    ),
                  )
                  .toList(),
            ),
            // ListView.builder(
            //   itemBuilder: (ctx, index) {
            //     return TransactionItem(transaction: transactions[index], removeTx: removeTx);
            //   },
            //   itemCount: transactions.length,
            // ),
          );
  }
}
