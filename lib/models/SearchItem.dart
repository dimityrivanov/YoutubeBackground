import 'package:youtube_test/models/Id.dart';

class SearchItem {
  String etag;
  Id id;
  String kind;

  SearchItem({this.etag, this.id, this.kind});

  factory SearchItem.fromJson(Map<String, dynamic> json) {
    return SearchItem(
      etag: json['etag'],
      id: json['id'] != null ? Id.fromJson(json['id']) : null,
      kind: json['kind'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['etag'] = this.etag;
    data['kind'] = this.kind;
    if (this.id != null) {
      data['id'] = this.id.toJson();
    }
    return data;
  }
}
