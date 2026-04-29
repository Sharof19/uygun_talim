class Payment {
  final String id;
  final String amount;
  final String currency;
  final String status;
  final String createdAt;
  const Payment({
    required this.id,
    required this.amount,
    required this.currency,
    required this.status,
    required this.createdAt,
  });
}
