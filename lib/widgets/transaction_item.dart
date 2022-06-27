import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key? key,
    required this.transaction,
    required this.removeTx,
  }) : super(key: key);

  final Transaction transaction;
  final Function removeTx;

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  late Color _bgColor;

  @override
  void initState() {
    const availableColors = [
      Colors.red,
      Colors.black,
      Colors.blue,
      Colors.purple,
    ];

    _bgColor = availableColors[Random().nextInt(availableColors.length)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          backgroundColor: _bgColor,
          radius: 30,
          child: Padding(
            padding: EdgeInsets.all(6.0),
            child: FittedBox(child: Text('\$${widget.transaction.amount}')),
          ),
        ),
        title: Text(
          widget.transaction.title,
          style: TextStyle(color: Color.fromRGBO(220, 220, 220, 1)),
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(widget.transaction.date),
          style: TextStyle(color: Color.fromRGBO(220, 220, 220, 1)),
        ),
        trailing: IconButton(
          onPressed: () {
            widget.removeTx(widget.transaction.id);
          },
          icon: Icon(
            Icons.delete,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
