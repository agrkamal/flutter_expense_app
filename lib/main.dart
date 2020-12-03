import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/new_transactio.dart';
import './widgets/chart.dart';
import './const.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Transactions(),
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: kPrimarySwatch,
        ),
        debugShowCheckedModeBanner: false,
        title: 'Expence App',
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  var _showChart = false;

  void _addNewTransaction(
    String title,
    double amount,
    DateTime date,
  ) {
    Provider.of<Transactions>(context, listen: false).addtx(
      title,
      amount,
      date,
    );
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (context) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
        );
      },
    );
  }

  List<Transaction> get transactions {
    final trx = Provider.of<Transactions>(context).transactions;
    return trx.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  List<Widget> _buildLandscape(
    Widget trxWidget,
    MediaQueryData mediaQuery,
    AppBar appBar,
  ) {
    return [
      _showChart
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  1,
              child: Chart(transactions),
            )
          : trxWidget,
    ];
  }

  List<Widget> _buildPortrait(
      Widget trxWidget, MediaQueryData mediaQuery, AppBar appBar) {
    return [
      Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        child: Chart(transactions),
      ),
      Consumer<Transactions>(
        builder: (ctx, trx, child) {
          return trxWidget;
        },
      ),
    ];
  }

  Widget _buildAppBar(BuildContext context, bool isLandscape) {
    return AppBar(
      backgroundColor: kPrimaryColor,
      centerTitle: true,
      title: const Text(
        'Daily Expences',
        style: TextStyle(
          color: kAccentColor,
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
      ),
      actions: <Widget>[
        IconButton(
          color: kButtonColor,
          icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        ),
        if (isLandscape && transactions.length > 0)
          Switch(
            inactiveThumbColor: kButtonColor,
            activeColor: kAccentColor,
            activeTrackColor: kButtonColor,
            inactiveTrackColor: Colors.blueGrey,
            value: _showChart,
            onChanged: (newVal) {
              setState(() {
                _showChart = newVal;
              });
            },
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final trx = Provider.of<Transactions>(context);
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = _buildAppBar(context, isLandscape);
    final trxWidget = Container(
      height: isLandscape
          ? (MediaQuery.of(context).size.height -
                  appBar.preferredSize.height -
                  mediaQuery.padding.top) *
              1
          : (MediaQuery.of(context).size.height -
                  appBar.preferredSize.height -
                  mediaQuery.padding.top) *
              0.7,
      child: TransactionList(),
    );
    return Scaffold(
      backgroundColor: kBackGroundColor,
      appBar: appBar,
      body: FutureBuilder(
          future: Provider.of<Transactions>(context).fetchAndSetTx(),
          builder: (ctx, snapshot) {
            return trx.transactions.isEmpty
                ? Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Container(color: Colors.transparent),
                        Positioned(
                          top: width > 450
                              ? MediaQuery.of(context).size.height * 0.1
                              : MediaQuery.of(context).size.height * 0.223,
                          child: const Icon(
                            Icons.sentiment_very_dissatisfied,
                            size: 170,
                            color: kButtonColor,
                          ),
                        ),
                        Positioned(
                          top: width > 450
                              ? MediaQuery.of(context).size.height * 0.6
                              : MediaQuery.of(context).size.height * 0.5,
                          // bottom: MediaQuery.of(context).size.height * 0.3,
                          child: const Text(
                            'No Transaction Added Yet!',
                            style: const TextStyle(
                              color: kPrimaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        if (!isLandscape)
                          ..._buildPortrait(
                            trxWidget,
                            mediaQuery,
                            appBar,
                          ),
                        if (isLandscape)
                          ..._buildLandscape(
                            trxWidget,
                            mediaQuery,
                            appBar,
                          ),
                      ],
                    ),
                  );
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _showChart
          ? null
          : FloatingActionButton(
              // mini: true,
              elevation: 10,
              tooltip: 'Add Transaction',
              backgroundColor: kAccentColor,
              focusColor: kAccentColor,
              splashColor: kAccentColor,
              onPressed: () => _startAddNewTransaction(context),
              child: const Icon(
                Icons.add,
                size: 30,
                color: kButtonColor,
              ),
            ),
    );
  }
}
