import 'dart:io';

class Post {
  final String content;
  final File? image;
  final String profileName;
  final File? profileImage;
  final List<String> comments;

  Post({
    required this.content,
    this.image,
    required this.profileName,
    this.profileImage,
    this.comments = const [],
  });
}

