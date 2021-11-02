import 'dart:convert';

import 'package:http/http.dart' as http;

class Post {
  final String id;
  final String title;
  final String markdownContentUrl;

  const Post({
    required this.id,
    required this.markdownContentUrl,
    required this.title,
  });

  static Post fromJson(Map<String, dynamic> input) {
    return Post(title: input["title"], markdownContentUrl: input["markdownContentUrl"], id: input["id"]);
  }

  String get relativeContentUrl => "$id/$markdownContentUrl";
}

class Catalog {
  final List<Post> posts;

  const Catalog({required this.posts});

  static Future<Catalog> initFromUrl(String url) async {
    final response = await http.get(Uri.parse("$url/catalog/catalog.json"));
    final body = response.body;
    final parsedBody = jsonDecode(body);
    final List jsonPosts = parsedBody["posts"] as List;
    final List<Post> posts = jsonPosts.map((e) => Post.fromJson(e)).toList();
    return Catalog(posts: posts);
  }
}
