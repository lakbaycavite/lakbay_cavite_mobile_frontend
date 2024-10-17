import 'dart:io';

import 'comment_model.dart';

class Post {
  final String id;
  final String content;
  final String profileName;
  final String? imageUrl;
  final File? profileImage;
  final File? image;
  bool liked;
  bool bookmarked;
  List<Comment> comments;

  Post({
    required this.id,
    required this.content,
    required this.profileName,
    required this.comments,
    this.imageUrl,
    this.profileImage,
    this.image,
    this.liked = false,
    this.bookmarked = false,
  }) ;
}