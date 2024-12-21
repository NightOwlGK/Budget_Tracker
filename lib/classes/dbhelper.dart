import 'dart:io';

import 'package:budget_tracker/constants/database_queries.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();

  static final DBHelper _instance = DBHelper._();

  static DBHelper getInstance() {
    return _instance;
  }

  Database? myDb;

  Future<Database> getDB() async {
    if (myDb != null) {
      return myDb!;
    } else {
      myDb = await openDB();
      return myDb!;
    }
  }

  Future<Database> openDB() async {
    Directory appDir = await getApplicationCacheDirectory();
    String dbPath = join(appDir.path, "accountNameDB.db");

    return await openDatabase(
      dbPath,
      onCreate: (db, version) async {
        await db.execute(signupTableCeateQuery);
        await db.execute(accountTableCreateQuery);
        await db.execute(transactionCreateTableQuery);
      },
      version: 1,
    );
  }

  Future<bool> addUser({
    required String username,
    required String email,
    required String password,
  }) async {
    var db = await getDB();

    bool emailExists = await checkIfEmailExists(email);

    if (emailExists) {
      return false;
    }

    int rowEffected = await db.insert(signUpTableName, {
      "username": username,
      "email": email,
      "password": password,
    });

    return rowEffected > 0;
  }

  Future<bool> checkIfEmailExists(String email) async {
    var db = await getDB();

    List<Map<String, dynamic>> results = await db.query(
      signUpTableName,
      columns: ["id"],
      where: "email = ?",
      whereArgs: [email],
    );

    return results.isNotEmpty;
  }

  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    var db = await getDB();

    bool emailExists = await checkIfEmailExists(email);

    if (!emailExists) {
      return false;
    }

    List<Map<String, dynamic>> results = await db.query(
      signUpTableName,
      columns: ["id"],
      where: "email = ? AND password = ?",
      whereArgs: [email, password],
    );

    return results.isNotEmpty;
  }

  Future<bool> addAccountName(
      {required String email, required String accountName}) async {
    var db = await getDB();

    bool isAccountExists =
        await checkIfAccountNameExists(email: email, accountName: accountName);
    if (isAccountExists) {
      return false;
    }
    int rowEffected = await db
        .insert(tableName, {"email": email, "accountName": accountName});
    return rowEffected > 0;
  }

  Future<List<String>> getAllAccountNames({required String email}) async {
    var db = await getDB();
    List<Map<String, dynamic>> results = await db.query(
      tableName,
      columns: ["accountName"],
      where: "email = ?",
      whereArgs: [email],
    );

    return results.map((row) => row["accountName"] as String).toList();
  }

  Future<void> editAccountName(
      {required String email,
      required String oldAccountName,
      required String newAccountName}) async {
    var db = await getDB();
    await db.update(
        tableName,
        {
          "email": email,
          "accountName": newAccountName,
        },
        where: "email = ? AND accountName = ?",
        whereArgs: [email, oldAccountName]);
  }

  Future<bool> deleteAccount(
      {required String email, required String accountName}) async {
    var db = await getDB();
    int rowEffected = await db.delete(tableName,
        where: "email = ? AND accountName = ?",
        whereArgs: [email, accountName]);
    return rowEffected > 0;
  }

  Future<bool> checkIfAccountNameExists(
      {required String email, required String accountName}) async {
    var db = await getDB();

    List<Map<String, dynamic>> results = await db.query(
      tableName,
      columns: ["id"],
      where: "email = ? AND accountName = ?",
      whereArgs: [email, accountName],
    );
    return results.isNotEmpty;
  }

  Future<bool> addTransactionAmount(
      {required String email,
      required String accountName,
      required String perticular,
      required int credited,
      required int debited}) async {
    var db = await getDB();
    int rowEffected = await db.insert(transactionTable, {
      "email": email,
      "accountName": accountName,
      "perticular": perticular,
      "credited_amount": credited,
      "debited_amount": debited,
    });
    return rowEffected > 0;
  }

  Future<bool> deleteAccountTransaction({required int id}) async {
    var db = await getDB();
    int rowEffected =
        await db.delete(transactionTable, where: "id = ?", whereArgs: [id]);
    return rowEffected > 0;
  }

  Future<List<Map<String, dynamic>>> getAllAccountTransactionDetail(
      {required String email, required String accountName}) async {
    var db = await getDB();
    List<Map<String, dynamic>> results = await db.query(transactionTable,
        where: "email = ? AND accountName = ?",
        whereArgs: [email, accountName]);
    return results;
  }

  Future<double> getSumOfCreditedColumn({
    required String email,
    required String accountName,
  }) async {
    var db = await getDB();
    var result = await db.rawQuery(
      '''
    SELECT SUM(credited_amount) as total 
    FROM $transactionTable 
    WHERE email = ? AND accountName = ?
    ''',
      [email, accountName],
    );

    if (result.isNotEmpty && result.first['total'] != null) {
      return result.first['total'] as double;
    }

    return 0.0;
  }

  Future<double> getSumOfDebitedColumn({
    required String email,
    required String accountName,
  }) async {
    var db = await getDB();
    var result = await db.rawQuery(
      '''
    SELECT SUM(debited_amount) as total 
    FROM $transactionTable 
    WHERE email = ? AND accountName = ?
    ''',
      [email, accountName],
    );

    if (result.isNotEmpty && result.first['total'] != null) {
      return result.first['total'] as double;
    }

    return 0.0;
  }
}
