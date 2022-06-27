import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:personal_expenses/widgets/transaction_list.dart';
import 'package:personal_expenses/widgets/new_transaction.dart';
import 'package:personal_expenses/models/transaction.dart';
import 'package:personal_expenses/widgets/chart.dart';

void main() {
  //Disable Landscape Mode
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Personal Expenses",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.black, //fromRGBO(245, 245, 245, 1),
        fontFamily: 'Quicksand',
        // ignore: deprecated_member_use
        appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                fontWeight: FontWeight.bold)),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transaction> _userTransactions = [
    //Transaction(id: UniqueKey(), title: "haha", amount: 12, date: DateTime.now())
  ];

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (ctx) {
          return SingleChildScrollView(
            child: NewTransaction(_addNewTransaction),
          );
        });
  }

  void _addNewTransaction(String txTitle, double txAmount, DateTime) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: DateTime,
      id: DateTime.toString(),
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("build scaffold");
    //final mediaQuery = MediaQuery.of(context);
    final appBar = AppBar(
      title: Text('Personal Expenses'),
      actions: [
        IconButton(
          onPressed: () => _startAddNewTransaction(context),
          icon: Icon(Icons.add_chart),
        ),
      ],
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      body: LayoutBuilder(
          builder: (BuildContext context, final BoxConstraints constraints) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  height: (constraints.maxHeight - 20) * 0.3,
                  child: Chart(_userTransactions),
                ),
                Container(
                    height: (constraints.maxHeight - 20) * 0.7,
                    child:
                        TransactionList(_userTransactions, _deleteTransaction)),
              ],
            ),
          ),
        );
      }),
    );
  }
}
