class HubM {
  final int id;
  final String name;
   bool isSelected;

  HubM({this.id, this.name,this.isSelected});

  factory HubM.fromJson(Map<String, dynamic> json) {
    return HubM(
      id: json['id'],
      name: json['name'],
    );
  }
}