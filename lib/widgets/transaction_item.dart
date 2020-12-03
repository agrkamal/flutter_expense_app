import 'package:Expences/const.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/transaction.dart';

class TransactionItem extends StatelessWidget {
  final String title;
  final double amount;
  final DateTime date;
  final String id;

  TransactionItem(
    this.title,
    this.amount,
    this.date,
    this.id,
  );
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xFFCBCBCB).withOpacity(0.5),
      ),
      child: GridTile(
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              child: Container(
                height: width > 450 ? 50 : 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: kPrimaryColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Text(
                      '₹$amount',
                      style: const TextStyle(
                        color: Color(0xFFFF9966),
                        fontWeight: FontWeight.bold,
                        // fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 32,
              left: 10,
              child: Container(
                width: width > 450
                    ? MediaQuery.of(context).size.width * 0.279
                    : MediaQuery.of(context).size.width * 0.4,
                child: Text(
                  title,
                  style: TextStyle(
                    color: kButtonColor,
                    fontWeight: FontWeight.bold,
                    fontSize: width > 450 ? 20 : 18,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              child: Text(
                DateFormat.yMMMEd().format(date),
                style: const TextStyle(
                  color: Color(0xFF616161),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            Positioned(
              bottom: -7,
              right: -5,
              child: IconButton(
                splashColor: kAccentColor,
                color: Color(0xFFCBCBCB),
                icon: const Icon(
                  Icons.delete,
                  size: 22,
                ),
                onPressed: () {
                  Provider.of<Transactions>(context, listen: false)
                      .deleteTx(id);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
