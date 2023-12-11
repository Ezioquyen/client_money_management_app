import '../data/network/network_api_service.dart';
import '../res/api_url.dart';
class RecordRepository{
  final _apiNetworkService = NetworkApiService();
  Future<dynamic> getAllRecordsByUsersAndHouseApi(String houseId, int userId) async{
    dynamic response = await _apiNetworkService.getApi("${ApiUrl.recordApi}/$houseId/$userId");
    return response;
  }
  Future<dynamic> getRecordsByUsersAndGroupApi(String houseId, int userId, int groupId) async{
   dynamic response = await _apiNetworkService.getApi("${ApiUrl.recordApi}/$houseId/$userId/$groupId");
    return response;
  }
  Future<dynamic> getAllRecordsByPayerAndHouseApi(String houseId, int payerId) async{
    dynamic response = await _apiNetworkService.getApi("${ApiUrl.recordApi}/payer/$houseId/$payerId");
    return response;
  }
  Future<dynamic> getRecordsByPayerAndGroupApi(String houseId, int payerId, int groupId) async{
    dynamic response = await _apiNetworkService.getApi("${ApiUrl.recordApi}/payer/$houseId/$payerId/$groupId");
    return response;
  }
  Future<dynamic> getRecordsByPayerOtherApi(String houseId, int payerId) async{
    dynamic response = await _apiNetworkService.getApi("${ApiUrl.recordApi}/payer/other/$houseId/$payerId");
    return response;
  }
  Future<dynamic> getRecordsByUserOtherApi(String houseId, int userId) async{
    dynamic response = await _apiNetworkService.getApi("${ApiUrl.recordApi}/other/$houseId/$userId");
    return response;
  }
  Future<dynamic> getRecordsByHouseForAllMemberApi(String houseId) async{
    dynamic response = await _apiNetworkService.getApi("${ApiUrl.recordApi}/house/$houseId");
    return response;
  }
  Future<dynamic> getRecordsByPayerAndHouseApi(String houseId, int payerId) async{
    dynamic response = await _apiNetworkService.getApi("${ApiUrl.recordApi}/payer/house/$houseId/$payerId");
    return response;
  }
  Future<dynamic> createRecordApi(var data) async{
    dynamic response = await _apiNetworkService.postApi(data,"${ApiUrl.recordApi}/create");
    return response;
  }

}