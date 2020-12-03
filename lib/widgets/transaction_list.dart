import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/transaction.dart';
import './transaction_item.dart';

class TransactionList extends StatefulWidget {
  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final tx = Provider.of<Transactions>(context);
    return FutureBuilder(
      future: Provider.of<Transactions>(context).fetchAndSetTx(),
      builder: (ctx, snapshot) => Container(
        padding: EdgeInsets.only(
            ),
        height: MediaQuery.of(context).size.height,
        child: GridView.builder(
          itemCount: tx.transactions.length,
          itemBuilder: (ctx, index) => TransactionItem(
            tx.transactions[index].title,
            tx.transactions[index].amount,
            tx.transactions[index].date,
            tx.transactions[index].id,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: width > 450 ? 3 : 2,
            childAspectRatio: width > 450 ? 2 / 1.35 : 3 / 2,
          ),
        ),
      ),
    );
  }
}
