import 'dart:convert';

import 'package:http/http.dart' as http;
class Catalog {
  final List<CatalogPostItem> posts;

  const Catalog({required this.posts});

  static Future<Catalog> initFromUrl(String url) async {
    final response = await http.get(Uri.parse("$url/catalog/catalog.json"));
    final body = response.body;
    final parsedBody = jsonDecode(body);
    final List jsonPosts = parsedBody["posts"] as List;
    final List<CatalogPostItem> posts = jsonPosts.map((e) => CatalogPostItem.fromJson(e)).toList();
    return Catalog(posts: posts);
  }
}

class CatalogPostItem {
  final String id;
  final String title;

  const CatalogPostItem({
    required this.id,
    required this.title,
  });

  static CatalogPostItem fromJson(Map<String, dynamic> input) {
    return CatalogPostItem(title: input["title"], id: input["id"]);
  }

  static Future<String> contentFromId(String id) async {
    final response = await http.get(Uri.parse(id));
    final body = response.body;
    return body;
  }
}
