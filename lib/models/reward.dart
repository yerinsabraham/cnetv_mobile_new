class Reward {
  final String id;
  final String type;
  final double amount;
  final String status;
  final String timestamp;

  Reward({
    required this.id,
    required this.type,
    required this.amount,
    required this.status,
    required this.timestamp,
  });

  factory Reward.fromJson(Map<String, dynamic> json) {
    return Reward(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      timestamp: json['timestamp'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'amount': amount,
        'status': status,
        'timestamp': timestamp,
      };
}
