// lib/app/modules/community/models/post_model.dart

class ForumPost {
  final int id;
  final String userName;
  final String? avatar;
  final String content;
  final int likes;
  final int comments;
  final DateTime createdAt;
  final DateTime updatedAt;

  ForumPost({
    required this.id,
    required this.userName,
    this.avatar,
    required this.content,
    required this.likes,
    required this.comments,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ForumPost.fromJson(Map<String, dynamic> json) {
    return ForumPost(
      id: json['id'] ?? 0,
      userName: (json['user_name'] as String?)?.trim().isNotEmpty == true
          ? json['user_name']
          : 'Anonymous',
      avatar: json['avatar'] as String?,
      content: (json['content'] as String?)?.trim() ?? 'No content',
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? json['comment_count'] ?? 0, // support both
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  ForumPost copyWith({
    String? content,
    int? likes,
    int? comments,
  }) {
    return ForumPost(
      id: id,
      userName: userName,
      avatar: avatar,
      content: content ?? this.content,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // CRITICAL FIX: For removeWhere() and GetX reactivity
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ForumPost && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class ForumComment {
  final int id;
  final int postId;
  final String userName;
  final String? avatar;
  final String content;
  final DateTime createdAt;

  ForumComment({
    required this.id,
    required this.postId,
    required this.userName,
    this.avatar,
    required this.content,
    required this.createdAt,
  });

  factory ForumComment.fromJson(Map<String, dynamic> json) {
    final String? rawName = json['user_name'] as String?;
    final String name = (rawName != null && rawName.trim().isNotEmpty)
        ? rawName.trim()
        : 'Anonymous';

    return ForumComment(
      id: json['id'] ?? 0,
      postId: json['post'] ?? 0,
      userName: name,
      avatar: json['avatar'] as String?,
      content: (json['content'] as String?)?.trim() ?? '',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}