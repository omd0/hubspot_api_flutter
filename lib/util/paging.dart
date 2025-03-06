class Paging {
  final String? link;
  final String? after;

  Paging({
    required this.link,
    required this.after,
  });

  factory Paging.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Paging(link: null, after: null);
    }
    return Paging(
      link: json['link'],
      after: json['after'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'link': link,
      'after': after,
    };
  }
}
