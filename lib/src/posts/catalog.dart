import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:metapersona/src/utils.dart';
class Catalog {
  final List<CatalogPostItem> posts;

  const Catalog({required this.posts});

  static Future<Catalog> initFromUrl(String url) async {
    final response = await http.get(Uri.parse("${url}catalog/catalog.json"));
    final utf8Body = utf8.decode(response.bodyBytes);
    final parser = Parser(utf8Body);
    final parsedBody = await parser.parseJsonInIsolate();
    final List jsonPosts = parsedBody["posts"] as List;
    final List<CatalogPostItem> posts = jsonPosts.map((e) => CatalogPostItem.fromJson(e)).toList();
    return Catalog(posts: posts);
  }
}

class CatalogPostItem {
  final String id;
  final String title;
  final String? thumbnail;
  DateTime? dateAdded;
  final List<String> tags;

  String? getFullThumbnail() {
    return thumbnail == null ? null : "${getRootUrlPrefix()}catalog/posts/$id/$thumbnail";
  }

  CatalogPostItem({
    required this.id,
    required this.title,
    required this.tags,
    this.dateAdded,
    this.thumbnail,
  });

  static CatalogPostItem fromJson(Map<String, dynamic> input) {
    var tagsJson = input["tags"] as List?;
    List<String> tags = tagsJson == null ? [] : tagsJson.map<String>((e) => e).toList();
    final dateAddedRaw = input["dateAdded"];
    DateTime? date;
    try {
      date = DateTime.parse(dateAddedRaw);
    } catch (e) {
      debugPrint("Could not parse dateAdded: $dateAddedRaw for post ${input["id"]}");
    }
    return CatalogPostItem(title: input["title"], id: input["id"], thumbnail: input["thumbnail"], tags: tags, dateAdded: date);
  }

  static Future<String> contentFromId(String id) async {
    final response = await http.get(Uri.parse(id));
    final body = response.body;
    return body;
  }
}
