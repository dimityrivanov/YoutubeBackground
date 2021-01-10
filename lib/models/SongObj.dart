class SongObj {
  String name;
  String thumb_url;
  String url;
  String time;
  String author;

  SongObj({this.name, this.thumb_url, this.url, this.time, this.author});

  factory SongObj.fromJson(Map<String, dynamic> json) {
    return SongObj(
      name: json['name'],
      time: json['time'],
      author: json['author'],
      thumb_url: json['thumb_url'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['time'] = this.time;
    data['author'] = this.author;
    data['thumb_url'] = this.thumb_url;
    data['url'] = this.url;
    return data;
  }
}
