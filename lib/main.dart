import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_news_reader/article_screen.dart';
import 'package:flutter_news_reader/model/news_model.dart';
import 'package:http/http.dart' as http;


Future<List<Source>> getSources() async
{
  final response = await http.get(
      'https://newsapi.org/v2/sources?apiKey=0e95e2d4e7f146549c58c2b152ccaa34');

  if (response.statusCode == 200) {
    List sources = json.decode(response.body)['sources'];
    print('size of list is: ${sources.length}');
    return sources.map((source) => new Source.fromJson(source)).toList();
  } else
    throw Exception('failed to get lists');
}


void main() => runApp(new SourceScreen());


class SourceScreen extends StatefulWidget {
  @override
  _SourceScreenState createState() => new _SourceScreenState();
}

class _SourceScreenState extends State<SourceScreen> {

  var source_list;
  var refresh_key = GlobalKey<RefreshIndicatorState>();


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News Reader App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('News App'),
        ),
        body: Center(
          child: RefreshIndicator(
            child: FutureBuilder<List<Source>>(
              future: source_list, builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Source> sources = snapshot.data;

                return ListView(
                  children: sources.map((source) =>
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) =>
                                  ArticleScreen(source: source,)));
                        }
                        ,
                        child: Card(
                          elevation: 2.0,
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 12.0),
                          child: new Row(

                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 2.0),
                                width: 100.0,
                                height: 140.0,
                                child: Image.asset('assets/news.png'),

                              ),

                              Expanded(child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              top: 20.0),
                                          child: Text('${source.name}',
                                            style: TextStyle(fontSize: 18.0,
                                                fontWeight: FontWeight.bold),),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 10.0),

                                    child: Text(source.description,
                                      style: TextStyle(fontSize: 14.0,
                                          color: Colors.grey
                                      ),),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 4.0),
                                    child: Text('Categoty: ${source.category}',
                                      style: TextStyle(fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  )

                                ],
                              ))
                            ],

                          ),
                        ),
                      )).toList(),
                );
              } else if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');

              return CircularProgressIndicator();
            },),
            onRefresh: refreshList,
            key: refresh_key,),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshList();
  }

  Future<Null> refreshList() async {
    refresh_key.currentState?.show(atTop: true);

    setState(() {
      source_list = getSources();
    });

    return null;
  }


}
