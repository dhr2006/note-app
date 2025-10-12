class Note {
  final String id;
  final String userId;
  final String title;
  final String content;
  final DateTime createdAt;

  Note({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'title': title,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }
}