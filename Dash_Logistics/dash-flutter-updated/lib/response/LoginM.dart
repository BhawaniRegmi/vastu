
class LoginResponse {
  Data data;
  List<Error> error;

  LoginResponse({this.data,this.error});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    data =
    json['data'] != null ? new Data.fromJson(json['data']) : null;
    error = json["errors"] == null ? null : List<Error>.from(json["errors"].map((x) => Error.fromJson(x)));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }

    if (this.error != null) {
      data['errors'] = this.error == null ? null : List<dynamic>.from(this.error.map((x) => x.toJson()));
    }
    return data;
  }
}

class Error {
  String title;
  String detail;

  Error({this.title, this.detail});

  Error.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    detail = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['detail'] = this.detail;
    return data;
  }
}




class Data {
  String tokenType;
  int expiresIn;
  String accessToken;
  String refreshToken;

  Data({this.tokenType, this.expiresIn, this.accessToken, this.refreshToken});

  Data.fromJson(Map<String, dynamic> json) {
    tokenType = json['tokenType'];
    expiresIn = json['expiresIn'];
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tokenType'] = this.tokenType;
    data['expiresIn'] = this.expiresIn;
    data['accessToken'] = this.accessToken;
    data['refreshToken'] = this.refreshToken;
    return data;
  }
}
