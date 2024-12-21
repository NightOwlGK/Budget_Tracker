import 'package:budget_tracker/classes/dbhelper.dart';
import 'package:budget_tracker/classes/transaction_model.dart';
import 'package:flutter/material.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage(
      {super.key, required this.accountName, required this.email});
  final String accountName;
  final String email;

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  String accountName = "";
  String email = "";
  final GlobalKey<FormState> _key = GlobalKey();
  List<TransactionModel> listOfTransactions = [];
  double creditSum = 0;
  double debitSum = 0;
  ValueNotifier<List<TransactionModel>> listOfTransactionNotifier =
      ValueNotifier([]);
  ValueNotifier<double> creditSumNotifier = ValueNotifier(0.0);
  ValueNotifier<double> debitSumNotifier = ValueNotifier(0.0);

  Future<void> getAllTransactionHistory(
      {required String email, required String accountName}) async {
    listOfTransactions.clear();
    List<Map<String, dynamic>> results = await DBHelper.getInstance()
        .getAllAccountTransactionDetail(email: email, accountName: accountName);

    for (int i = 0; i < results.length; i++) {
      listOfTransactions.add(TransactionModel(
        id: results[i]["id"] as int,
        email: results[i]["email"] as String? ?? '',
        accountName: results[i]["account_name"] as String? ?? '',
        date: results[i]["transaction_date"] as String? ?? '',
        particular: results[i]["perticular"] as String? ?? '',
        credited: results[i]["credited_amount"]?.toString() ?? '0',
        debited: results[i]["debited_amount"]?.toString() ?? '0',
      ));
    }
    listOfTransactionNotifier.value = List.from(listOfTransactions);
  }

  Future<void> getSumOfDebit(
      {required String email, required String accountName}) async {
    double result = await DBHelper.getInstance()
        .getSumOfDebitedColumn(email: email, accountName: accountName);
    debitSumNotifier.value = result;
  }

  Future<void> getSumOfCredit(
      {required String email, required String accountName}) async {
    double result = await DBHelper.getInstance()
        .getSumOfCreditedColumn(email: email, accountName: accountName);
    creditSumNotifier.value = result;
  }

  @override
  void initState() {
    super.initState();
    email = widget.email;
    accountName = widget.accountName;
    getAllTransactionHistory(email: email, accountName: accountName);
    getSumOfCredit(email: email, accountName: accountName);
    getSumOfDebit(email: email, accountName: accountName);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: Container(
        height: size.height * 0.1,
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Total Credits (↑)",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    ValueListenableBuilder(
                      valueListenable: creditSumNotifier,
                      builder: (_, cred, ___) {
                        return Text(
                          "$cred",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Total Debits (↓)",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    ValueListenableBuilder(
                      valueListenable: debitSumNotifier,
                      builder: (_, deb, ___) {
                        return Text(
                          "$deb",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(accountName),
        actions: [
          IconButton(
            onPressed: () {
              _showDialog();
            },
            icon: Icon(Icons.note_add),
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            color: const Color.fromARGB(255, 188, 188, 188),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Center(
                        child: Text(
                      "Date",
                      textAlign: TextAlign.center,
                    )),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Center(
                        child: Text(
                      "Particular",
                      textAlign: TextAlign.center,
                    )),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Center(
                      child: Text(
                        "Credited",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Center(
                      child: Text(
                        "Debited",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ValueListenableBuilder<List<TransactionModel>>(
            valueListenable: listOfTransactionNotifier,
            builder: (_, listOfTran, __) {
              return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: listOfTran.length,
                itemBuilder: (context, index) {
                  final transaction = listOfTran[index];
                  return CustomTransactionCard(
                    transaction: transaction,
                    calback: () {
                      _showDeleteDialogBox(id: transaction.id);
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _deleteTransactionAmount({required int id}) async {
    bool isDelete =
        await DBHelper.getInstance().deleteAccountTransaction(id: id);
    if (isDelete) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Transaction deleted suceessfully")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Something went wrong...")));
    }
    getAllTransactionHistory(email: email, accountName: accountName);
    await getSumOfCredit(email: email, accountName: accountName);
    await getSumOfDebit(email: email, accountName: accountName);
  }

  void _showDeleteDialogBox({required int id}) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Are you sure you want to delete this ?",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      side: BorderSide(color: Colors.black),
                    ),
                    onPressed: () {
                      _deleteTransactionAmount(id: id);
                      Navigator.pop(context);
                    },
                    child: Text(
                      "YES",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      side: BorderSide(color: Colors.black),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "NO",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDialog() {
    TextEditingController perticularController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    List<String> options = ["Credit", "Debit"];
    String currentSelected = "Credit";

    Future<void> onSubmit() async {
      bool isValid = _key.currentState!.validate();
      if (!isValid) {
        return;
      }
      _key.currentState!.save();

      String preticular = perticularController.text.trim().toString();
      String amt = amountController.text.trim().toString();
      int amount = int.parse(amt);
      perticularController.clear();
      amountController.clear();
      await addTransactionAmount(
        email: email,
        accountName: accountName,
        perticular: preticular,
        credited: currentSelected == options[0] ? amount : 0,
        debited: currentSelected == options[1] ? amount : 0,
      );
    }

    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          child: StatefulBuilder(
            builder: (context, setStateDialog) {
              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Form(
                    key: _key,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          "Add New Transaction",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          style: Theme.of(context).textTheme.titleSmall,
                          cursorColor: Colors.amber,
                          controller: perticularController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            label: Text(
                              "Particular",
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Transaction type:",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Radio<String>(
                              value: options[0],
                              groupValue: currentSelected,
                              onChanged: (value) {
                                setStateDialog(() {
                                  currentSelected = value!;
                                });
                              },
                              activeColor: Colors.greenAccent,
                            ),
                            Radio<String>(
                              value: options[1],
                              groupValue: currentSelected,
                              onChanged: (value) {
                                setStateDialog(() {
                                  currentSelected = value!;
                                });
                              },
                              activeColor: Colors.redAccent,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          style: Theme.of(context).textTheme.titleSmall,
                          cursorColor: Colors.amber,
                          controller: amountController,
                          validator: (value) {
                            if (value!.contains(".")) {
                              return "Please don't enter point values";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            label: Text("Amount"),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextButton(
                          style: TextButton.styleFrom(
                            side: BorderSide(color: Colors.black),
                          ),
                          onPressed: () async {
                            onSubmit();
                          },
                          child: Text("SAVE"),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            side: BorderSide(color: Colors.black),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("CANCEL"),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> addTransactionAmount(
      {required String email,
      required String accountName,
      required String perticular,
      required int credited,
      required int debited}) async {
    bool isAdded = await DBHelper.getInstance().addTransactionAmount(
        email: email,
        accountName: accountName,
        perticular: perticular,
        credited: credited,
        debited: debited);

    if (isAdded) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Successfully added Transaction")));
      await getAllTransactionHistory(email: email, accountName: accountName);

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Something went wrong...")));
    }
    await getSumOfCredit(email: email, accountName: accountName);
    await getSumOfDebit(email: email, accountName: accountName);
  }
}

class CustomTransactionCard extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback calback;

  const CustomTransactionCard(
      {super.key, required this.transaction, required this.calback});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: calback,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: transaction.credited != "0.0"
              ? Colors.green[100]
              : Colors.red[100],
          border: Border.symmetric(
            horizontal: BorderSide(color: Colors.black, width: 0.5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Center(
                  child: Text(
                transaction.date,
                textAlign: TextAlign.center,
              )),
            ),
            Expanded(
              child: Center(
                  child: Text(
                transaction.particular,
                textAlign: TextAlign.center,
              )),
            ),
            Expanded(
              child: Center(
                child: Text(
                  transaction.credited,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  transaction.debited,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
