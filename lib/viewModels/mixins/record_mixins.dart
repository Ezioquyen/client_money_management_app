
import '../../models/house.dart';
import '../../models/payment_group.dart';
import '../../models/record.dart';
import '../../models/user/user.dart';
import '../../repository/record_repository.dart';


mixin RecordMixin{
  int paid = 0;
  int debt = 0;
  final recordRepository = RecordRepository();
  User user = User(id: 0, username: 'user', email: 'example@gmail.com');
  dynamic selectedDate;
  List<PaymentGroup> groups = [];
  late List<dynamic> dateList = [];
  List<RecordPayment> records = [];
   House house = House(
      id: '', name: 'Loading', information: '', role: true, date: '06/12/2023');
  Future<void> updateDate(dynamic date) async {
    selectedDate = date;
    await getDebtAndPaid();
    await getAllRecordsByUsersAndHouse();
  }
  Future<dynamic> getAllRecordsByUsersAndHouse() async {
    List<dynamic> response =
    await recordRepository.getAllRecordsByUsersAndHouseApi(
        house.id,
        user.id,
        selectedDate.toString().split("/")[1],
        selectedDate.toString().split("/")[0]);
    records = response
        .map((jsonObject) => RecordPayment.fromJson(jsonObject))
        .toList();

  }

  Future<dynamic> createRecord(var data) async {
    await recordRepository.createRecordApi(data);

  }

  Future<dynamic> saveRecord(var data, var id) async {

    await recordRepository.saveRecordApi(data, id);

  }
  Future<dynamic> getDebtAndPaid() async {
    debt = await recordRepository.findDebtMoneyByDate(user.id, house.id, selectedDate.toString().split("/")[1],
        selectedDate.toString().split("/")[0]);
    paid = await recordRepository.findPaidMoneyByDate(user.id, house.id, selectedDate.toString().split("/")[1],
        selectedDate.toString().split("/")[0]);
  }
}