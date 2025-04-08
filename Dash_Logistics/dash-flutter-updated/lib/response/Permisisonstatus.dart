class ForwardStatus {
  final String key;
  final String name;
  List<String> status;

  ForwardStatus({
    this.key,
    this.name,
    this.status,
  });

  factory ForwardStatus.fromJson(Map<String, dynamic> json) {
    return ForwardStatus(
      status: json['apiStatusPermission'] != null
          ?  List.from(json['apiStatusPermission'])
          : null,
      key: json['key'],
      name: json['name'],
    );
  }
}


