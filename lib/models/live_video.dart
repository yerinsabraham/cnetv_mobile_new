class LiveVideo {
  final String id;
  final String title;
  final String url;
  final String thumbnail;
  final String status;

  LiveVideo({
    required this.id,
    required this.title,
    required this.url,
    required this.thumbnail,
    required this.status,
  });

  factory LiveVideo.fromJson(Map<String, dynamic> json) {
    return LiveVideo(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'url': url,
        'thumbnail': thumbnail,
        'status': status,
      };
}
