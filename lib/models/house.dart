
class House{
  String id;
  String name;
  String information;
  String date;
  bool role;

  House({this.id ='', this.name ='',  this.date ='',this.information ='', this.role = false});
  factory House.fromJson(Map<String, dynamic> json) {
    return House(
      id: json['id'] ?? '',
      information: json['information'] ?? '',
      date: json['date'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'information': information,
      'date': date
    };
  }
}