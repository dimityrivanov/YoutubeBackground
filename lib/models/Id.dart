class Id {
    String kind;
    String videoId;

    Id({this.kind, this.videoId});

    factory Id.fromJson(Map<String, dynamic> json) {
        return Id(
            kind: json['kind'], 
            videoId: json['videoId'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['kind'] = this.kind;
        data['videoId'] = this.videoId;
        return data;
    }
}