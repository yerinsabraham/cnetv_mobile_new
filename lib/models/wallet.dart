import 'reward.dart';

class Wallet {
  final String id;
  final String userId;
  final double balance;
  final List<Reward> transactions;

  Wallet({
    required this.id,
    required this.userId,
    required this.balance,
    required this.transactions,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    var transactionsJson = json['transactions'] as List? ?? [];
    List<Reward> transactionsList = transactionsJson.map((e) => Reward.fromJson(e)).toList();

    return Wallet(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      balance: (json['balance'] ?? 0).toDouble(),
      transactions: transactionsList,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'balance': balance,
        'transactions': transactions.map((e) => e.toJson()).toList(),
      };
}
