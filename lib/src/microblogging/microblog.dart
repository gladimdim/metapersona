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
  final DateTime? dateAdded;
  final String? languageEmoji;
  static const String defaultLanguage = "🇺🇸";

  MicroBlogItem({required this.content, this.thumbnail, this.dateAdded, this.languageEmoji});

  static MicroBlogItem fromJson(Map<String, dynamic> input) {
    var dateTimeString = input["dateAdded"];
    DateTime? date;
    if (dateTimeString != null) {
      date = DateTime.parse(dateTimeString);
    }
    var lang =  input["languageEmoji"] ?? MicroBlogItem.defaultLanguage;
    return MicroBlogItem(content: input["content"], thumbnail: input["thumbnail"], dateAdded: date, languageEmoji: lang);
  }
}