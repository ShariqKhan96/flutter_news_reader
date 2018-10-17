/*
public class Source
{
    public string id { get; set; }
    public string name { get; set; }
    public string description { get; set; }
    public string url { get; set; }
    public string category { get; set; }
    public string language { get; set; }
    public string country { get; set; }
}


public class Article
{
    public Source source { get; set; }
    public string author { get; set; }
    public string title { get; set; }
    public string description { get; set; }
    public string url { get; set; }
    public string urlToImage { get; set; }
    public DateTime publishedAt { get; set; }
    public string content { get; set; }
}

 */

class Article {
  Source source;
  String author;
  String title;
  String description;
  String url;
  String urlToImage;
  String publishedAt;
  String content;

  Article({this.source, this.author, this.title, this.description, this.url,
    this.urlToImage, this.publishedAt, this.content});

  factory Article.fromJson(Map<String, dynamic> json)
  {
    return Article(
        source: Source.fromJsonFromArticle(json['source'],),
        author: json['author'],
        title: json['title'],
        description: json['description'],
        url: json['url'],
        urlToImage: json['urlToImage'],
        publishedAt: json['publishedAt'],
        content: json['content']

    );
  }


}

class NewsApi {
  final String status;
  final List<Source> sources;

  NewsApi({this.status, this.sources});

  factory NewsApi.fromJson(Map<String, dynamic> json)
  {
    return NewsApi(status: json['status'].toString(),
        sources: (json['sources'] as List).map((source) =>
            Source.fromJson(source)).toList());
  }

}

class Source {
  final String id, name, description, url, category, language, country;

  Source({this.id, this.name, this.description, this.url, this.category,
    this.language, this.country});

  factory Source.fromJson(Map<String, dynamic> json)
  {
    return Source(
        id: json['id'].toString(),
        name: json['name'].toString(),
        description: json['description'].toString(),
        url: json['url'].toString(),
        category: json['category'].toString(),
        language: json['language'].toString(),
        country: json['country'].toString());
  }

  factory Source.fromJsonFromArticle(Map<String, dynamic> json)
  {
    return Source(
        id: json['id'].toString(),
        name: json['name'].toString());
  }
}

