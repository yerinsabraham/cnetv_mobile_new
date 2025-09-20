class PollOption {
  final String id;
  final String text;
  final int votes;

  PollOption({
    required this.id,
    required this.text,
    required this.votes,
  });

  factory PollOption.fromJson(Map<String, dynamic> json) {
    return PollOption(
      id: json['id'] ?? '',
      text: json['text'] ?? '',
      votes: json['votes'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'votes': votes,
      };
}

class Poll {
  final String id;
  final String question;
  final List<PollOption> options;
  final String status;

  Poll({
    required this.id,
    required this.question,
    required this.options,
    required this.status,
  });

  factory Poll.fromJson(Map<String, dynamic> json) {
    var optionsJson = json['options'] as List? ?? [];
    List<PollOption> optionsList = optionsJson.map((e) => PollOption.fromJson(e)).toList();

    return Poll(
      id: json['id'] ?? '',
      question: json['question'] ?? '',
      options: optionsList,
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'question': question,
        'options': options.map((e) => e.toJson()).toList(),
        'status': status,
      };
}
