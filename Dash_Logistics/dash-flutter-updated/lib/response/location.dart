class Location {
  final int id;
  final String name;
  bool isSelected;

  Location({this.id, this.name,this.isSelected});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      name: json['name'],
    );
  }
}