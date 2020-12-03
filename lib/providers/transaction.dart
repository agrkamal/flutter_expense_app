import 'package:flutter/foundation.dart';

import '../helper/database.dart';

class Transaction {
  Transaction({
    this.id,
    this.title,
    this.amount,
    this.date,
  });

  final String title;
  final String id;
  final double amount;
  final DateTime date;
}

class Transactions with ChangeNotifier {
  List<Transaction> _transactions = [];

  List<Transaction> get transactions {
    return [..._transactions];
  }

  void addtx(
    String title,
    double amount,
    DateTime date,
  ) {
    final newTx = Transaction(
      id: DateTime.now().toIso8601String(),
      title: title,
      amount: amount,
      date: date,
    );
    _transactions.add(newTx);
    DBHelper.insert('user_trnx', {
      'id': newTx.id,
      'title': newTx.title,
      'amount': newTx.amount,
      'date': newTx.date.toIso8601String(),
    });
    notifyListeners();
  }

  Future<void> fetchAndSetTx() async {
    final dataList = await DBHelper.getData('user_trnx');
    final trx = dataList
        .map(
          (tx) => Transaction(
            id: tx['id'],
            title: tx['title'],
            amount: tx['amount'],
            date: DateTime.parse(tx['date']),
          ),
        )
        .toList();
    _transactions = trx;
    notifyListeners();
  }

  void deleteTx(String id) {
    _transactions.removeWhere((element) => element.id == id);
    DBHelper.deleteTx('user_trnx', id);
    notifyListeners();
  }
}
