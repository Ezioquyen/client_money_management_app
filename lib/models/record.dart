class RecordPayment{
  int id = 0;
  int money;
  String date;
  String information;
  int paymentGroup;
  bool paid;
  int payerId;
  String houseId;
  List<int> participantIds;
  RecordPayment({required this.participantIds,required this.houseId, required this.paymentGroup,required this.id, required this.money, required this.date, required this.information, required this.paid, required this.payerId});
  factory RecordPayment.fromJson(Map<String, dynamic> json) {
    return RecordPayment(
      id: json['id'] ?? 0,
      money: json['money'] ?? 0,
      date: json['date']?? '',
      information: json['information'] ?? '',
      paymentGroup: json['paymentGroup'] ?? '',
      paid: json['paid'] ?? false,
      payerId: json['payerId'] ?? 0,
      houseId: json['houseId'] ?? '',
      participantIds: List<int>.from(json['participantIds']),
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