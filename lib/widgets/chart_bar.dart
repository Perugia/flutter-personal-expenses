import 'package:flutter/material.dart';
import 'dart:math';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPctOfTotal;

  ChartBar(this.label, this.spendingAmount, this.spendingPctOfTotal);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return Column(
          children: [
            Container(
              height: constraints.maxHeight * 0.15, //20
              child: FittedBox(
                child: Text(
                  '\$${spendingAmount.toStringAsFixed(0)}',
                  style: TextStyle(color: Color.fromRGBO(220, 220, 220, 1)),
                ),
              ),
            ),
            SizedBox(
              height: constraints.maxHeight * 0.05, //4
            ),
            Container(
              height: constraints.maxHeight * 0.6, //60
              width: 10,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.0),
                      color: Color.fromRGBO(220, 220, 220, 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  FractionallySizedBox(
                    heightFactor: spendingPctOfTotal,
                    child: Transform.translate(
                      offset: Offset(0.0, constraints.maxHeight * 0.6),
                      child: Container(
                        transform: Matrix4.rotationX(pi),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: constraints.maxHeight * 0.05,
            ),
            Container(
              height: constraints.maxHeight * 0.10,
              child: FittedBox(
                child: Text(label,
                    style: TextStyle(color: Color.fromRGBO(220, 220, 220, 1))),
              ),
            )
          ],
        );
      },
    );
  }
}
