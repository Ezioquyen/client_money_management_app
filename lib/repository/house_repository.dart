import 'package:untitled1/data/network/network_api_service.dart';
import 'package:untitled1/models/house.dart';


import 'package:untitled1/res/api_url.dart';

class HouseRepository{
  final _apiNetworkService = NetworkApiService();
  Future<dynamic> getHouseApi(int id) async{
    dynamic response = await _apiNetworkService.getApi("${ApiUrl.userApi}/houses/$id");
    return response;
  }
  Future<dynamic> checkUserHouseApi(int id, String houseId) async{
    dynamic response = await _apiNetworkService.getApi("${ApiUrl.houseApi}/$houseId/$id");
    return response;
  }
  Future<dynamic> isHouseExistApi(String id) async{
    dynamic response = await _apiNetworkService.getApi("${ApiUrl.houseApi}/$id/check");
    return response;
  }
  Future<dynamic> createHouse(House house) async{
    dynamic response = await _apiNetworkService.putApi(house.toJson(), "${ApiUrl.houseApi}/create");
    return response;
  }
  Future<dynamic> joinHouse(var data) async{
    dynamic response = await _apiNetworkService.putApi(data,'${ApiUrl.houseApi}/join');
    return response;
  }
  Future<dynamic> isUserHasHouse(int id) async {
    dynamic response = await _apiNetworkService.getApi('${ApiUrl.userApi}/house_check/$id');
    return response;
  }
  Future<dynamic> updateName(String id,String data) async {
    await _apiNetworkService.putApi(data,'${ApiUrl.houseApi}/update_name/$id');
  }
  Future<dynamic> oldCheck(String houseId,int userId) async {
   return await _apiNetworkService.getApi('${ApiUrl.houseApi}/check_old_user/$houseId/$userId');
  }
  Future<dynamic> joinOld(String id,int uId) async {
    await _apiNetworkService.putApi(null,'${ApiUrl.houseApi}/join_old_user/$id/$uId');
  }

}