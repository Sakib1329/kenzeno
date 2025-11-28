class Article {
  final int id;
  final String title;
  final String content;
  final String? mediaUrl;
  final String category;
  final String createdBy;
  final DateTime createdAt;

  Article({
    required this.id,
    required this.title,
    required this.content,
    this.mediaUrl,
    required this.category,
    required this.createdBy,
    required this.createdAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      mediaUrl: json['media_url'] as String?,  // nullable
      category: json['category'] as String,
      createdBy: json['created_by'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'media_url': mediaUrl,
      'category': category,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
