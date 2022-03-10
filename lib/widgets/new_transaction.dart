import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

final _textController = TextEditingController();
final _amountController = TextEditingController();
DateTime _selectedDate = DateTime.now();

class NewTransaction extends StatefulWidget {
  final Function AddTxHandler;
  NewTransaction(this.AddTxHandler) {
    print("Constructor NewTransaction Widget");
  }

  @override
  State<NewTransaction> createState() {
    print('createState newTransaction Widget');
    return _NewTransactionState();
  }
}

class _NewTransactionState extends State<NewTransaction>
    with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();

  _NewTransactionState() {
    print("Constructor NewTransaction State");
  }

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

    _textController.clear();
    _amountController.clear();
    _selectedDate = DateTime.now();
    Navigator.pop(context);
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
    print("initState()");
    amountTextFocus = FocusNode();
    chooseDateFocus = FocusNode();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print("didUpDateWidget()");
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    print("dispose()");
    amountTextFocus.dispose();
    chooseDateFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Container(
      width: 300,
      padding: EdgeInsets.only(bottom: (mediaQuery.viewInsets.bottom)),
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Form(
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
                          //focusNode: chooseDateFocus,
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
                      SnackBar(content: Text('Successfully added!')),
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
