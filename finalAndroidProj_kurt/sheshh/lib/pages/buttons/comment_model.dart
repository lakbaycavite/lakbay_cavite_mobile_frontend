class Comment {
  final String comment;
  final String username;
  final String createdAt;
  final String text;

// Constructor with required fields
  Comment({
    required this.text,
    required this.comment,
    required this.username,
    required this.createdAt,
  });
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      username: json['username'], // Adjust according to your API response
      text: json['text'], comment: '', createdAt: '',
    );
  }
}

