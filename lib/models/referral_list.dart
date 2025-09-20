import 'user.dart';

class ReferralList {
  final String id;
  final String userId;
  final List<User> referredUsers;
  final double rewards;

  ReferralList({
    required this.id,
    required this.userId,
    required this.referredUsers,
    required this.rewards,
  });

  factory ReferralList.fromJson(Map<String, dynamic> json) {
    var usersJson = json['referredUsers'] as List? ?? [];
    List<User> usersList = usersJson.map((e) => User.fromJson(e)).toList();

    return ReferralList(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      referredUsers: usersList,
      rewards: (json['rewards'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'referredUsers': referredUsers.map((e) => e.toJson()).toList(),
        'rewards': rewards,
      };
}
