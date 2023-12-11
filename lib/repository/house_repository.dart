import 'package:untitled1/data/network/network_api_service.dart';
import 'package:untitled1/models/house.dart';
import 'package:untitled1/models/user_house.dart';

import 'package:untitled1/res/api_url.dart';

class HouseRepository{
  final _apiNetworkService = NetworkApiService();
  Future<dynamic> getUsersByHouseApi(String id) async{
    dynamic response = await _apiNetworkService.getApi("${ApiUrl.houseApi}/$id/users");
    return response;
  }
  Future<dynamic> getHouseApi(String email) async{
    dynamic response = await _apiNetworkService.getApi("${ApiUrl.userApi}/$email/houses");
    return response;
  }
  Future<dynamic> checkUserHouseApi(String email, String houseId) async{
    dynamic response = await _apiNetworkService.getApi("${ApiUrl.houseApi}/$houseId/$email");
    return response;
  }
  Future<dynamic> isHouseExistApi(String id) async{
    dynamic response = await _apiNetworkService.getApi("${ApiUrl.houseApi}/$id/check");
    return response;
  }
  Future<dynamic> createHouse(House house) async{
    dynamic response = await _apiNetworkService.postApi(house.toJson(), "${ApiUrl.houseApi}/create");
    return response;
  }
  Future<dynamic> joinHouse(UserHouse userHouse, String houseId, int userId) async{
    dynamic response = await _apiNetworkService.postApi(userHouse.toJson(),'${ApiUrl.houseApi}/join/$houseId/$userId');
    return response;
  }
  Future<dynamic> isUserHasHouse(int id) async {
    dynamic response = await _apiNetworkService.getApi('${ApiUrl.userApi}/$id/house_check');
    return response;
  }
}