import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_page/helper/data.dart';
import 'package:news_page/helper/widgets.dart';
import 'package:news_page/models/categorie_model.dart';
import 'package:news_page/views/categorie_news.dart';
import '../helper/news.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool _loading;
  var newslist;

  List<CategorieModel> categories = [];

  void getNews() async {
    News news = News();
    await news.parse();
    newslist = news.list_news;
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    _loading = true;

    super.initState();

    categories = getCategories();
    getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      body: SafeArea(
        child: _loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      /// Categories
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        height: 40,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length ~/ 2,
                            itemBuilder: (context, index) {
                              return CategoryCard(
                                imageAssetUrl: categories[index].imageAssetUrl,
                                categoryName: categories[index].categorieName,
                              );
                            }),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        height: 40,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length ~/ 2,
                            itemBuilder: (context, index) {
                              return CategoryCard(
                                imageAssetUrl: categories[
                                        index + categories.length ~/ 2 - 1]
                                    .imageAssetUrl,
                                categoryName: categories[
                                        index + categories.length ~/ 2 - 1]
                                    .categorieName,
                              );
                            }),
                      ),

                      /// News Article
                      Container(
                        margin: EdgeInsets.only(top: 16),
                        child: ListView.builder(
                            itemCount: newslist.length,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return NewsTile(
                                imgUrl: newslist[index].urlToImage ?? "",
                                title: newslist[index].title ?? "",
                                desc: newslist[index].description ?? "",
                                content: newslist[index].content ?? "",
                                posturl: newslist[index].articleUrl ?? "",
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String imageAssetUrl, categoryName;

  const CategoryCard(
      {Key? key, required this.imageAssetUrl, required this.categoryName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryNews(
                      newsCategory: categoryName.toLowerCase(),
                    )));
      },
      child: Container(
        margin: EdgeInsets.only(right: 14),
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              height: 30,
              width: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.blue),
              child: Text(
                categoryName,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      ),
    );
  }
}
