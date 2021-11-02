import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:metapersona/src/utils.dart';
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
  final String? thumbnail;
  final List<String> tags;

  String? getFullThumbnail() {
    return thumbnail == null ? null : "${getRootUrlPrefix()}/catalog/posts/$id/$thumbnail";
  }

  const CatalogPostItem({
    required this.id,
    required this.title,
    required this.tags,
    this.thumbnail,
  });

  static CatalogPostItem fromJson(Map<String, dynamic> input) {
    List<String> tags = (input["tags"] as List).map<String>((e) => e).toList();
    return CatalogPostItem(title: input["title"], id: input["id"], thumbnail: input["thumbnail"], tags: tags);
  }

  static Future<String> contentFromId(String id) async {
    final response = await http.get(Uri.parse(id));
    final body = response.body;
    return body;
  }
}
