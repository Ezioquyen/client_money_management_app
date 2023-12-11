import 'package:untitled1/repository/record_repository.dart';

import '../models/record.dart';

class RecordProvider{
  
  final _recordRepository = RecordRepository();
  Future<dynamic> getAllRecordsByUsersAndHouse(String houseId, int userId) async{
    List<dynamic> response = await _recordRepository.getAllRecordsByUsersAndHouseApi(houseId, userId);
    List<RecordPayment> records = response.map((jsonObject) => RecordPayment.fromJson(jsonObject)).toList();
    return records;
  }
  Future<dynamic> getRecordsByUsersAndGroup(String houseId, int userId, int groupId) async{
    List<dynamic> response = await _recordRepository.getRecordsByUsersAndGroupApi(houseId, userId, groupId);
    List<RecordPayment> records = response.map((jsonObject) => RecordPayment.fromJson(jsonObject)).toList();
    return records;
  }
  Future<dynamic> getAllRecordsByPayerAndHouse(String houseId, int payerId) async{
    List<dynamic> response = await _recordRepository.getAllRecordsByPayerAndHouseApi(houseId, payerId);
    List<RecordPayment> records = response.map((jsonObject) => RecordPayment.fromJson(jsonObject)).toList();
    return records;
  }
  Future<dynamic> getRecordsByPayerAndGroup(String houseId, int payerId, int groupId) async{
    List<dynamic> response = await _recordRepository.getRecordsByPayerAndGroupApi(houseId, payerId, groupId);
    List<RecordPayment> records = response.map((jsonObject) => RecordPayment.fromJson(jsonObject)).toList();
    return records;
  }
  Future<dynamic> getRecordsByPayerOther(String houseId, int payerId) async{
    List<dynamic> response = await _recordRepository.getRecordsByPayerOtherApi(houseId, payerId);
    List<RecordPayment> records = response.map((jsonObject) => RecordPayment.fromJson(jsonObject)).toList();
    return records;
  }
  Future<dynamic> getRecordsByUserOther(String houseId, int userId) async{
    List<dynamic> response = await _recordRepository.getRecordsByUserOtherApi(houseId, userId);
    List<RecordPayment> records = response.map((jsonObject) => RecordPayment.fromJson(jsonObject)).toList();
    return records;
  }
  Future<dynamic> getRecordsByHouseForAllMember(String houseId) async{
    List<dynamic> response = await _recordRepository.getRecordsByHouseForAllMemberApi(houseId);
    List<RecordPayment> records = response.map((jsonObject) => RecordPayment.fromJson(jsonObject)).toList();
    return records;
  }
  Future<dynamic> getRecordsByPayerAndHouse(String houseId, int payerId) async{
    List<dynamic> response = await _recordRepository.getAllRecordsByPayerAndHouseApi(houseId, payerId);
    List<RecordPayment> records = response.map((jsonObject) => RecordPayment.fromJson(jsonObject)).toList();
    return records;
  }
  Future<dynamic> createRecord(var data) async{
    List<dynamic> response = await _recordRepository.createRecordApi(data);
    List<RecordPayment> records = response.map((jsonObject) => RecordPayment.fromJson(jsonObject)).toList();
    return records;
  }

}