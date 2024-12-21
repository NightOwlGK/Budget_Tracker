class TransactionModel {
  final int id;
  final String email;
  final String accountName;
  final String date;
  final String particular;
  final String credited;
  final String debited;

  TransactionModel({
    required this.id,
    required this.email,
    required this.accountName,
    required this.date,
    required this.particular,
    required this.credited,
    required this.debited,
  });
}
