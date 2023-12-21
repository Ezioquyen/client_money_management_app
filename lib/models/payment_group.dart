class PaymentGroup{
  String name;
  int id;
  String houseId;
  List<int> userIds;
 PaymentGroup({required this.id, required this.name,required this.houseId,required this.userIds});
  factory PaymentGroup.fromJson(Map<String, dynamic> json) {
    return PaymentGroup(
      id: json['id'] ?? '',
      houseId: json['houseId'] ?? '',
      name: json['name'] ?? '',
      userIds: List<int>.from(json['userIds']),

    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'houseId': houseId,
      'usersIds': userIds
    };
  }
}