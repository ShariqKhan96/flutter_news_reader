import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_news_reader/model/news_model.dart';
import 'package:url_launcher/url_launcher.dart';


Future<List<Article>> getArticlesBySource(String source) async
{
  final response = await http.get(
      'https://newsapi.org/v2/top-headlines?sources=${source}&apiKey=0e95e2d4e7f146549c58c2b152ccaa34');

  if (response.statusCode == 200) {
    List sources = json.decode(response.body)['articles'];
    print('size of list is: ${sources.length}');
    return sources.map((article) => new Article.fromJson(article)).toList();
  } else
    throw Exception('failed to get articles');
}


class ArticleScreen extends StatefulWidget {
  Source source;

  @override
  _ArticleScreenState createState() => new _ArticleScreenState();

  ArticleScreen({Key key, @required this.source}) : super(key: key);
}

class _ArticleScreenState extends State<ArticleScreen> {

  var list_articles;
  var refresh_key = GlobalKey<RefreshIndicatorState>();


  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'News App',
      theme: ThemeData(
          primarySwatch: Colors.teal
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.source.name),
        ),
        body: Center(
          child: RefreshIndicator(key: refresh_key,
              child: FutureBuilder<List<Article>>
                (builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                } else if (snapshot.hasData) {
                  List<Article> list = snapshot.data;
                  return ListView(
                    children: list.map((article) =>
                        GestureDetector(
                          onTap: () {
                            _launchUrl(article.url);
                          },

                          child: Card(
                            elevation: 1.0,
                            color: Colors.white,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 4.0),
                                  width: 100.0,
                                  height: 100.0,
                                  child: article.urlToImage != null ? Image
                                      .network(article.urlToImage) : Image
                                      .asset('assets/news.png'),

                                ),

                                Expanded(child: Container(
                                  margin: EdgeInsets.all(10.0),

                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,

                                    children: <Widget>[
                                      SizedBox(width: double.infinity,
                                        height: 10.0,),
                                      Text('${article.title}',
                                        style: TextStyle(fontSize: 18.0,
                                            fontWeight: FontWeight.bold),),
                                      SizedBox(width: double.infinity,
                                        height: 10.0,),
                                      Text('${article.description}',
                                        style: TextStyle(fontSize: 13.5,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold),),
                                      SizedBox(
                                        width: double.infinity, height: 10.0,),
                                      Text('${article.publishedAt}',
                                        style: TextStyle(fontSize: 12.0,
                                            color: Colors.grey),)

                                    ],
                                  ),
                                ))


                              ],
                            ),

                          ),
                        )).toList()
                    ,
                  );
                }

                return
                  CircularProgressIndicator
                    (
                  );
              },
                future: list_articles,
              ),
              onRefresh: refreshArticlesList),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshArticlesList();
  }


  Future<Null> refreshArticlesList() async {
    refresh_key.currentState?.show(atTop: true);


    setState(() {
      list_articles = getArticlesBySource(widget.source.id);
    });

    return null;
  }


  void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else
      throw Exception('Couldn\'t launch ${url}');
  }
}


