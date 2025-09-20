class User {
  final String id;
  final String name;
  final String email;
  final String profilePic;
  final double walletBalance;
  final String token;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.profilePic,
    required this.walletBalance,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profilePic: json['profilePic'] ?? '',
      walletBalance: (json['walletBalance'] ?? 0).toDouble(),
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'profilePic': profilePic,
        'walletBalance': walletBalance,
        'token': token,
      };
}
