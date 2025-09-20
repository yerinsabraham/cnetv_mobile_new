class ProgramVideo {
  final String id;
  final String title;
  final String url;
  final String thumbnail;
  final int duration; // in seconds

  ProgramVideo({
    required this.id,
    required this.title,
    required this.url,
    required this.thumbnail,
    required this.duration,
  });

  factory ProgramVideo.fromJson(Map<String, dynamic> json) {
    return ProgramVideo(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      duration: json['duration'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'url': url,
        'thumbnail': thumbnail,
        'duration': duration,
      };
}

class Program {
  final String id;
  final String name;
  final List<ProgramVideo> videos;
  final String schedule; // e.g., daily, weekly

  Program({
    required this.id,
    required this.name,
    required this.videos,
    required this.schedule,
  });

  factory Program.fromJson(Map<String, dynamic> json) {
    var videosJson = json['videos'] as List? ?? [];
    List<ProgramVideo> videosList = videosJson.map((e) => ProgramVideo.fromJson(e)).toList();

    return Program(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      videos: videosList,
      schedule: json['schedule'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'videos': videos.map((e) => e.toJson()).toList(),
        'schedule': schedule,
      };
}
