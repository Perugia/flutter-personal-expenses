import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function AddTxHandler;
  BuildContext ctx;

  NewTransaction(this.AddTxHandler, this.ctx);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _formKey = GlobalKey<FormState>();

  final _textController = TextEditingController();
  final _amountController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  void _submitData() {
    final enteredTitle = _textController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty ||
        enteredAmount == null ||
        enteredAmount <= 0 ||
        _selectedDate == null) {
      return;
    }

    widget.AddTxHandler(
      enteredTitle,
      enteredAmount,
      _selectedDate,
    );

    _textController.text = "";
    _amountController.text = "";
    Navigator.pop(widget.ctx);
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _selectedDate == null ? DateTime.now() : _selectedDate,
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
    print('...');
  }

  final List<DecimalTextForm> textfieldformats = [
    DecimalTextForm(RegExp(r'^[a-zA-Z0-9ğüşöçıİĞÜŞÖÇ ]+$')),
    DecimalTextForm(RegExp(r'^\d*\.?\d*$')),
  ];

  FocusNode amountTextFocus;
  FocusNode chooseDateFocus;

  @override
  void initState() {
    super.initState();

    amountTextFocus = FocusNode();
    chooseDateFocus = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    amountTextFocus.dispose();
    chooseDateFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding:
          EdgeInsets.only(bottom: (MediaQuery.of(context).viewInsets.bottom)),
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: "Title"),
                  controller: _textController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  inputFormatters: [
                    textfieldformats[0],
                    LengthLimitingTextInputFormatter(18),
                  ],
                  onFieldSubmitted: (_) => amountTextFocus.requestFocus(),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Amount"),
                  controller: _amountController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  focusNode: amountTextFocus,
                  inputFormatters: [
                    textfieldformats[1],
                    LengthLimitingTextInputFormatter(7),
                  ],
                  keyboardType: TextInputType.number,
                  onFieldSubmitted: (_) => chooseDateFocus.requestFocus(),
                ),
                Container(
                  height: 70,
                  child: Row(
                    children: [
                      Text(
                        _selectedDate == null
                            ? 'No Date Chosen!'
                            : DateFormat.yMMMMd().format(_selectedDate),
                      ),
                      TextButton(
                          focusNode: chooseDateFocus,
                          onPressed: _presentDatePicker,
                          child: Text(
                            'Choose Date',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ))
                    ],
                  ),
                ),
                TextButton(
                  child: Text(
                    "Add Transaction",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _submitData();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Successfully added!')),
                      );
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    primary: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DecimalTextForm extends TextInputFormatter {
  final regEx;

  DecimalTextForm(this.regEx);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final String newString = regEx.stringMatch(newValue.text) ?? '';
    return newString == newValue.text ? newValue : oldValue;
  }
}
