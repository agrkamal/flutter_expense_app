import 'package:Expences/const.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../const.dart';

class NewTransaction extends StatefulWidget {
  NewTransaction(this.addTx);

  final Function addTx;

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = new TextEditingController();
  final _amountController = new TextEditingController();
  DateTime _selectedDate;
  final _amountFocus = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _amountFocus.dispose();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: width > 450
                ? MediaQuery.of(context).viewInsets.bottom + 30
                : MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                textInputAction: TextInputAction.next,
                onSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_amountFocus);
                },
                controller: _titleController,
                decoration:const  InputDecoration(
                  hintText: 'Enter Title',
                  labelText: 'Title',
                ),
                enableInteractiveSelection: true,
                enableSuggestions: true,
                textCapitalization: TextCapitalization.words,
              ),
              TextField(
                textInputAction: TextInputAction.done,
                focusNode: _amountFocus,
                controller: _amountController,
                decoration: const InputDecoration(
                  hintText: 'Enter Amount',
                  labelText: 'Amount',
                ),
                keyboardType: TextInputType.number,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    _selectedDate == null
                        ? 'No Date Chosen'
                        : DateFormat.yMMMEd().format(_selectedDate),
                  ),
                  FlatButton(
                    textColor: kPrimaryColor,
                    onPressed: _presentDatePicker,
                    child:const  Text('Select Date'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              RaisedButton.icon(
                textColor: kAccentColor,
                color: kButtonColor,
                colorBrightness: Brightness.light,
                onPressed: () {
                  if (_amountController.text.isEmpty) {
                    return;
                  }
                  final enteredTitle = _titleController.text;
                  final enteredAmount = double.parse(_amountController.text);

                  if (enteredTitle.isEmpty ||
                      enteredAmount <= 0 ||
                      _selectedDate == null) {
                    return;
                  }

                  widget.addTx(
                    enteredTitle,
                    enteredAmount,
                    _selectedDate,
                  );
                  Navigator.of(context).pop();
                },
                icon:const  Icon(Icons.add),
                label: const Text('Add Transaction'),
              ),
            ],
            crossAxisAlignment: CrossAxisAlignment.stretch,
          ),
        ),
      ),
    );
  }
}
