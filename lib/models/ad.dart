class Ad {
  final String id;
  final String title;
  final String imageUrl;

  Ad({required this.id, required this.title, required this.imageUrl});

  factory Ad.fromJson(Map<String, dynamic> json) {
    return Ad(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
