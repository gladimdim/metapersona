import 'dart:convert';

import 'package:http/http.dart' as http;

class MicroBlog {
  final List<MicroBlogItem> micros;
  static const storageFolderPath = "storage";

  MicroBlog({required this.micros});

  static String path = "micro";

  static Future<MicroBlog> initFromUrl(String url) async {
    final response = await http.get(Uri.parse("${url}micro/micros.json"));
    final utf8Body = utf8.decode(response.bodyBytes);
    final parsedBody = jsonDecode(utf8Body);
    return MicroBlog.fromJson(parsedBody);
  }

  static MicroBlog fromJson(Map<String, dynamic> input) {
    List posts = input["micros"] as List;
    List<MicroBlogItem> micros = posts.map((e) => MicroBlogItem.fromJson(e)).toList();
    return MicroBlog(micros: micros);
  }
}

class MicroBlogItem {
  final String content;
  final String? thumbnail;
  final DateTime? publishedOn;
  final List<String>? links;
  final String? languageEmoji;
  static const String defaultLanguage = "🇺🇸";

  MicroBlogItem({required this.content, this.thumbnail, this.publishedOn, this.links, this.languageEmoji});

  static MicroBlogItem fromJson(Map<String, dynamic> input) {
    var dateTimeString = input["publishedOn"];
    DateTime? date;
    if (dateTimeString != null) {
      date = DateTime.parse(dateTimeString);
    }
    var lang =  input["languageEmoji"] ?? MicroBlogItem.defaultLanguage;
    var linksJson = input["links"] as List;
    var links = linksJson.map<String>((e) => e).toList();
    return MicroBlogItem(content: input["content"], thumbnail: input["thumbnail"], publishedOn: date, languageEmoji: lang, links: links);
  }
}