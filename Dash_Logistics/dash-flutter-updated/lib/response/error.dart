
class Error {
  String title;
  String detail;

  Error({this.title, this.detail});

  factory Error.fromJson(Map<String, dynamic> json) {
    return Error(
      title: json['title'],
      detail: json['detail'],
    );
  }
}