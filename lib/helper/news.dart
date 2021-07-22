import 'package:http/http.dart' as http;
import 'package:news_page/models/news.dart';
import 'dart:convert';

import 'package:news_page/secret.dart';

abstract class Parse {
  static Future<String> get_request(String url) async {
    var response = await http.get(Uri.parse(url));

    return response.body;
  }
}

class News {
  List<News_modal> list_news = [];

  Future<void> parse() async {
    String url =
        "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=${apiKey}";

    var response = await Parse.get_request(url);
    Map<String, dynamic> jsonData = jsonDecode(response);
    if (jsonData['status'] == "ok") {
      jsonData["articles"].forEach((news_req) {
        if (news_req['urlToImage'] != null && news_req['description'] != null) {
          print("News --------------------------");
          print(news_req);
          News_modal news = News_modal.from_json(news_req);
          list_news.add(news);
        }
      });
    }
  }
}

class NewsForCategorie {
  List<News_modal> list_news = [];

  Future<void> parse(String category) async {
    String url =
        "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=${apiKey}";

    var response = await Parse.get_request(url);
    Map<String, dynamic> jsonData = jsonDecode(response);
    if (jsonData['status'] == "ok") {
      jsonData["articles"].forEach((news_req) {
        if (news_req['urlToImage'] != null && news_req['description'] != null) {
          print("News category --------------------------");
          print(news_req);
          News_modal news = News_modal.from_json(news_req);
          list_news.add(news);
        }
      });
    }
  }
}
