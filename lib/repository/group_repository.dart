import '../data/network/network_api_service.dart';
import '../res/api_url.dart';

class GroupRepository{
  final _apiNetworkService = NetworkApiService();
  Future<dynamic> createGroupApi(var data) async{
    dynamic response = await _apiNetworkService.putApi(data,"${ApiUrl.groupApi}/create");
    return response;
  }
  Future<dynamic> getGroupByUserAndHouseApi(String houseId, int userId) async{
    dynamic response = await _apiNetworkService.getApi("${ApiUrl.groupApi}/$houseId/$userId");
    return response;
  }
  Future<dynamic> getGroupById(int id) async{
    dynamic response = await _apiNetworkService.getApi("${ApiUrl.groupApi}/$id");
    return response;
  }
  Future<dynamic> getGroupByHouseApi(String houseId) async{
    dynamic response = await _apiNetworkService.getApi("${ApiUrl.groupApi}/house/$houseId");
    return response;
  }
  Future<dynamic> checkGroupByHouseApi(String houseId,String groupName) async{
    dynamic response = await _apiNetworkService.getApi("${ApiUrl.groupApi}/check/$houseId?name=${Uri.encodeFull(groupName)}");
    return response;
  }
  Future<dynamic> removeGroupByHouseApi(int id) async{
    dynamic response = await _apiNetworkService.putApi(null,"${ApiUrl.groupApi}/remove/$id");
    return response;
  }
}