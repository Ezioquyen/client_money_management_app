class Record{
  int id;
  int money;
  String date;
  String information;
  int paymentGroup;
  bool paid;
  int payerId;
  String houseId;
  List<int> participantIds;
  Record({required this.participantIds,required this.houseId, required this.paymentGroup,required this.id, required this.money, required this.date, required this.information, required this.paid, required this.payerId});
  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(
      id: json['id'] ?? 0,
      information: json['information'] ?? '',
      date: json['date'] ?? '',
      money: json['money'] ?? 0,
      paid: json['paid'] ?? false,
      payerId: json['payer'] ?? 0,
      paymentGroup:  json['paymentGroup'] ?? 0,
      houseId: json['houseId'] ?? '',
      participantIds: json['participantIds'] ?? {}
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'money': money,
      'information': information,
      'date': date,
      'paymentGroup': paymentGroup,
      'paid': paid,
      'payerId': payerId,
      'houseId': houseId,
      'participantIds': participantIds
    };
  }
}