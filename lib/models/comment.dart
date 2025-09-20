class Comment {
  final String id;
  final String userId;
  final String content;
  final String timestamp;
  final String? parentId;

  Comment({
    required this.id,
    required this.userId,
    required this.content,
    required this.timestamp,
    this.parentId,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      content: json['content'] ?? '',
      timestamp: json['timestamp'] ?? '',
      parentId: json['parentId'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'content': content,
        'timestamp': timestamp,
        'parentId': parentId,
      };
}
