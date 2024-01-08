import 'package:untitled1/models/user/user.dart';

class RecordPayment {
  String id;
  int money;
  String date;
  String information;
  int paymentGroup;
  bool paid;

  User payer = User();

  String houseId;
  List<int> participantIds;

  RecordPayment({
    required this.payer,
    required this.participantIds,
    this.houseId = '',
    this.paymentGroup = -1,
    this.id = '',
    this.money = 0,
    this.date = '',
    this.information = '',
    this.paid = false,
  });

  factory RecordPayment.fromJson(Map<String, dynamic> json) {
    return RecordPayment(
      id: json['id'] ?? '',
      money: json['money'] ?? 0,
      date: json['date'] ?? '',
      information: json['information'] ?? '',
      paymentGroup: json['paymentGroup'] ?? '',
      paid: json['paid'] ?? false,
      payer: User.fromJson(json['payer']),
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
      'payer': {
        "id": payer.id,
        "email": payer.email,
        "username": payer.username
      },
      'houseId': houseId,
      'participantIds': participantIds
    };
  }
}
