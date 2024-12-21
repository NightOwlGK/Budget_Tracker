import 'package:budget_tracker/classes/dbhelper.dart';
import 'package:budget_tracker/screens/login_page.dart';
import 'package:budget_tracker/screens/transaction_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final String email;
  const HomePage({super.key, required this.email});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _accountNameController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  late final email;
  List<String> listOfAccount = [];
  ValueNotifier<List<String>> listOfAccountNotifier = ValueNotifier([]);

  Future<void> getAllAccountNames({required String email}) async {
    listOfAccount =
        await DBHelper.getInstance().getAllAccountNames(email: email);
    listOfAccountNotifier.value = listOfAccount;
  }

  void changePrefContains() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("isLoggedIn", false);
    pref.setString("email", "");
  }

  @override
  void initState() {
    super.initState();
    email = widget.email;
    getAllAccountNames(email: email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Budget Tracker",
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              padding: EdgeInsets.all(0),
              child: Image.asset(
                "assets/images/drawerimage.jpg",
                fit: BoxFit.cover,
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pop();
              },
              title: Text(
                "Home",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 30),
              leading: Icon(Icons.home),
            ),
            ListTile(
              onTap: () {
                changePrefContains();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => LoginPage()));
              },
              title: Text(
                "Logout",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 30),
              leading: Icon(Icons.logout),
            ),
          ],
        ),
      ),
      body: ValueListenableBuilder(
          valueListenable: listOfAccountNotifier,
          builder: (_, listofAccount, __) {
            if (listofAccount.isEmpty) {
              return Center(
                child: Text(
                  "Add Account",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              );
            } else {
              return ListView.builder(
                itemCount: listofAccount.length,
                itemBuilder: (_, index) {
                  return CustomAccountCard(
                    accountName: listofAccount[index],
                    email: email,
                    deleteAccount: () {
                      _deleteAccount(
                          email: email, accountName: listofAccount[index]);
                    },
                  );
                },
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _showDialog,
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _deleteAccount(
      {required String email, required String accountName}) async {
    await DBHelper.getInstance()
        .deleteAccount(email: email, accountName: accountName);
    getAllAccountNames(email: email);
  }

  Future<void> addAccount(
      {required String email, required String accountName}) async {
    bool isVaild = _key.currentState!.validate();
    if (!isVaild) {
      return;
    }
    _key.currentState!.save();
    bool isAdded = await DBHelper.getInstance()
        .addAccountName(email: email, accountName: accountName);
    if (isAdded) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Account added Successfully")));
      await getAllAccountNames(email: email);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Account Name Already Exits")));
    }
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Form(
                key: _key,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      "Add New Account",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      style: Theme.of(context).textTheme.titleSmall,
                      cursorColor: Colors.amber,
                      validator: (value) {
                        if (value!.length > 15) {
                          return "Too big account name";
                        }
                        if (value.isEmpty) {
                          return "Enter account name";
                        }
                        return null;
                      },
                      controller: _accountNameController,
                      decoration: InputDecoration(
                        label: Text(
                          "Enter account name",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        addAccount(
                            email: email,
                            accountName:
                                _accountNameController.text.trim().toString());
                        _accountNameController.clear();
                      },
                      child: Text("SAVE"),
                    ),
                    SizedBox(height: 5),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _accountNameController.clear();
                      },
                      child: Text("CANCEL"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomAccountCard extends StatelessWidget {
  final String accountName;
  final VoidCallback deleteAccount;
  final String email;
  const CustomAccountCard({
    super.key,
    required this.accountName,
    required this.deleteAccount,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => TransactionPage(
                  accountName: accountName,
                  email: email,
                )));
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    accountName, //17
                    style: TextTheme.of(context).titleMedium,
                  ),
                  IconButton(
                    onPressed: deleteAccount,
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "Credit",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "Debit",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
