class House{
  String id;
  String name;
  String information;
  String date;
  bool role;
  House({required this.id, required this.name, required this.date,required this.information, required this.role});
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