import 'package:youtube_test/models/SearchItem.dart';
import 'package:youtube_test/models/PageInfo.dart';

class YoutubeSearchResult {
    String etag;
    List<SearchItem> items;
    String kind;
    String nextPageToken;
    PageInfo pageInfo;
    String regionCode;

    YoutubeSearchResult({this.etag, this.items, this.kind, this.nextPageToken, this.pageInfo, this.regionCode});

    factory YoutubeSearchResult.fromJson(Map<String, dynamic> json) {
        return YoutubeSearchResult(
            etag: json['etag'], 
            items: json['items'] != null ? (json['items'] as List).map((i) => SearchItem.fromJson(i)).toList() : null,
            kind: json['kind'], 
            nextPageToken: json['nextPageToken'], 
            pageInfo: json['pageInfo'] != null ? PageInfo.fromJson(json['pageInfo']) : null, 
            regionCode: json['regionCode'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['etag'] = this.etag;
        data['kind'] = this.kind;
        data['nextPageToken'] = this.nextPageToken;
        data['regionCode'] = this.regionCode;
        if (this.items != null) {
            data['items'] = this.items.map((v) => v.toJson()).toList();
        }
        if (this.pageInfo != null) {
            data['pageInfo'] = this.pageInfo.toJson();
        }
        return data;
    }
}