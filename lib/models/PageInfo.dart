class PageInfo {
    int resultsPerPage;
    int totalResults;

    PageInfo({this.resultsPerPage, this.totalResults});

    factory PageInfo.fromJson(Map<String, dynamic> json) {
        return PageInfo(
            resultsPerPage: json['resultsPerPage'], 
            totalResults: json['totalResults'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['resultsPerPage'] = this.resultsPerPage;
        data['totalResults'] = this.totalResults;
        return data;
    }
}