class YoutubeVideoResponse {
  String author_name;
  String video_url;
  String author_url;
  int height;
  String html;
  String provider_name;
  String provider_url;
  int thumbnail_height;
  String thumbnail_url;
  int thumbnail_width;
  String title;
  String type;
  String version;
  int width;

  YoutubeVideoResponse(
      {this.author_name,
      this.video_url,
      this.author_url,
      this.height,
      this.html,
      this.provider_name,
      this.provider_url,
      this.thumbnail_height,
      this.thumbnail_url,
      this.thumbnail_width,
      this.title,
      this.type,
      this.version,
      this.width});

  factory YoutubeVideoResponse.fromJson(Map<String, dynamic> json) {
    return YoutubeVideoResponse(
      author_name: json['author_name'],
      author_url: json['author_url'],
      height: json['height'],
      html: json['html'],
      provider_name: json['provider_name'],
      provider_url: json['provider_url'],
      thumbnail_height: json['thumbnail_height'],
      thumbnail_url: json['thumbnail_url'],
      thumbnail_width: json['thumbnail_width'],
      title: json['title'],
      type: json['type'],
      version: json['version'],
      width: json['width'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['author_name'] = this.author_name;
    data['author_url'] = this.author_url;
    data['height'] = this.height;
    data['html'] = this.html;
    data['provider_name'] = this.provider_name;
    data['provider_url'] = this.provider_url;
    data['thumbnail_height'] = this.thumbnail_height;
    data['thumbnail_url'] = this.thumbnail_url;
    data['thumbnail_width'] = this.thumbnail_width;
    data['title'] = this.title;
    data['type'] = this.type;
    data['version'] = this.version;
    data['width'] = this.width;
    return data;
  }
}
