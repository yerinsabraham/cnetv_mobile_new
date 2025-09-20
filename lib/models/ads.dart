class Ads {
  final String id;
  final String title;
  final String imageUrl;
  final String link;
  final String type;

  Ads({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.link,
    required this.type,
  });

  factory Ads.fromJson(Map<String, dynamic> json) {
    return Ads(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      link: json['link'] ?? '',
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'imageUrl': imageUrl,
        'link': link,
        'type': type,
      };
}
