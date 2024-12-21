const String accountTableCreateQuery = '''
  CREATE TABLE $tableName (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    email TEXT NOT NULL,
    accountName TEXT NOT NULL
  )
''';

const String tableName = "account";

const String signUpTableName = "signup";

const String signupTableCeateQuery = """
    CREATE TABLE $signUpTableName (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL
    )
""";

const String transactionTable = "transactionTable";

const String transactionCreateTableQuery = """
      CREATE TABLE $transactionTable(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      email TEXT NOT NULL,
      accountName TEXT NOT NULL,
      perticular TEXT NOT NULL,
      credited_amount REAL DEFAULT 0,
      debited_amount REAL DEFAULT 0,
      transaction_date DATE DEFAULT CURRENT_DATE
      )
 """;
