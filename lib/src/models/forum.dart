import 'package:owpet/src/models/user.dart';

class Forum {
  final String id;
  final String description;
  final List<String> images;
  final User user;
  final String createdAt;
  late int likeCount;
  late int dislikeCount;
  late int commentCount;
  late int shareCount;

  Forum({
    required this.id,
    required this.description,
    required this.images,
    required this.user,
    required this.createdAt,
    this.likeCount = 0,
    this.dislikeCount = 0,
    this.commentCount = 0, 
    this.shareCount = 0,
  });

  factory Forum.fromJson(Map<String, dynamic> json) {
    return Forum(
      id: json['id'],
      description: json['description'],
      images: List<String>.from(json['images']),
      user: User.fromJson(json['user']),
      createdAt: json['createdAt'],
      likeCount: json['likeCount'],
      dislikeCount: json['dislikeCount'],
      commentCount: json['commentCount'],
      shareCount: json['shareCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'images': images,
      'user': user.toJson(),
      'createdAt': createdAt,
      'likeCount': likeCount,
      'dislikeCount': dislikeCount,
      'commentCount': commentCount,
      'shareCount': shareCount,
    };
  }
}

class Comment {
  final String id;
  final String description;
  final User user;
  final String createdAt;
  late int likeCount;
  late int dislikeCount;

  Comment({
    required this.id,
    required this.description,
    required this.user,
    required this.createdAt,
    this.likeCount = 0,
    this.dislikeCount = 0,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      description: json['description'],
      user: User.fromJson(json['user']),
      createdAt: json['createdAt'],
      likeCount: json['likeCount'],
      dislikeCount: json['dislikeCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'user': user.toJson(),
      'createdAt': createdAt,
      'likeCount': likeCount,
      'dislikeCount': dislikeCount,
    };
  }
}