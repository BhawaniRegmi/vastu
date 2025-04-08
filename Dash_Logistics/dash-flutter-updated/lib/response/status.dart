class StatusM {
  final String key;
  final String name;
  final String group;
   bool isCurrentStatus;
   bool isSelected;
   bool isAllowed;

  StatusM({this.key, this.name,this.group,this.isCurrentStatus,this.isSelected,this.isAllowed});

  factory StatusM.fromJson(Map<String, dynamic> json) {
    return StatusM(
      key: json['key'],
      name: json['name'],
      group: json['group'],
    );
  }
}