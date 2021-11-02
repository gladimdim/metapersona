import 'dart:convert';

import 'package:http/http.dart' as http;

class Post {
  final String id;
  final String title;
  final String markdownContent;

  const Post({
    required this.id,
    required this.title,
    required this.markdownContent
  });


  static Future<String> contentFromId(String rootUrl, String id) async {
    final response = await http.get(Uri.parse("$rootUrl$id/content.md"));
    final body = response.body;
    return body;
  }

  static Future<Post> fromIdUrl(String rootUrl, String id) async {
    final mdContent = await contentFromId(rootUrl, id);
    final responsePost = await http.get(Uri.parse("$rootUrl$id/post.json"));
    final responseJson = jsonDecode(responsePost.body);
    return Post(
      id: responseJson["id"],
      title: responseJson["title"],
      markdownContent: mdContent,
    );
  }

}

