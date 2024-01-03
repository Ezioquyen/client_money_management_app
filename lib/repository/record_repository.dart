import '../data/network/network_api_service.dart';
import '../res/api_url.dart';
class RecordRepository{
  final _apiNetworkService = NetworkApiService();
  Future<dynamic> getAllRecordsByUsersAndHouseApi(String houseId, int userId, String year, String month) async{
    dynamic response = await _apiNetworkService.getApi("${ApiUrl.recordApi}/$houseId/$userId?year=$year&month=$month");
    return response;
  }
  Future<dynamic> getRecordsByUsersAndGroupApi(String houseId, int userId, int groupId, String year, String month) async{
   dynamic response = await _apiNetworkService.getApi("${ApiUrl.recordApi}/$houseId/$userId/$groupId?year=$year&month=$month");
    return response;
  }
  Future<dynamic> getAllRecordsByPayerAndHouseApi(String houseId, int payerId, String year, String month) async{
    dynamic response = await _apiNetworkService.getApi("${ApiUrl.recordApi}/payer/$houseId/$payerId?year=$year&month=$month");
    return response;
  }
  Future<dynamic> getRecordsByPayerAndGroupApi(String houseId, int payerId, int groupId, String year, String month) async{
    dynamic response = await _apiNetworkService.getApi("${ApiUrl.recordApi}/payer/$houseId/$payerId/$groupId?year=$year&month=$month");
    return response;
  }
  Future<dynamic> getRecordsByPayerOtherApi(String houseId, int payerId, String year, String month) async{
    dynamic response = await _apiNetworkService.getApi("${ApiUrl.recordApi}/payer/other/$houseId/$payerId?year=$year&month=$month");
    return response;
  }
  Future<dynamic> getRecordsByUserOtherApi(String houseId, int userId, String year, String month) async{
    dynamic response = await _apiNetworkService.getApi("${ApiUrl.recordApi}/other/$houseId/$userId?year=$year&month=$month");
    return response;
  }
  Future<dynamic> getRecordsByHouseForAllMemberApi(String houseId, String year, String month) async{
    dynamic response = await _apiNetworkService.getApi("${ApiUrl.recordApi}/house/$houseId?year=$year&month=$month");
    return response;
  }
  Future<dynamic> getRecordsByPayerAndHouseApi(String houseId, int payerId, String year, String month) async{
    dynamic response = await _apiNetworkService.getApi("${ApiUrl.recordApi}/payer/house/$houseId/$payerId?year=$year&month=$month");
    return response;
  }
  Future<dynamic> createRecordApi(var data) async{
    dynamic response = await _apiNetworkService.postApi(data,"${ApiUrl.recordApi}/create");
    return response;
  }
  Future<dynamic> saveRecordApi(var data, var id) async{
    dynamic response = await _apiNetworkService.putApi(data,"${ApiUrl.recordApi}/save/$id");
    return response;
  }
  Future<dynamic> getDateOfRecordsApi(String houseId) async{
    dynamic response = await _apiNetworkService.getApi("${ApiUrl.recordApi}/date/$houseId");
    return response;
  }
  Future<dynamic> findPaidMoneyByDate(var userId, var houseId, var year, var month) async{
    dynamic response = await _apiNetworkService.getApi("${ApiUrl.recordApi}/paid/$houseId/$userId?year=$year&month=$month");
    return response;
  }
  Future<dynamic> findDebtMoneyByDate(var userId, var houseId, var year, var month) async{
    dynamic response = await _apiNetworkService.getApi("${ApiUrl.recordApi}/debt/$houseId/$userId?year=$year&month=$month");
    return response;
  }
}