import '../data/network/network_api_service.dart';
import '../models/user/user.dart';
import '../res/api_url.dart';

class UserRepository {
  final _apiNetworkService = NetworkApiService();

  Future<dynamic> getUserApi(int id) async {
    dynamic response = await _apiNetworkService.getApi("${ApiUrl.userApi}/id/$id");
    return response;
  }
  Future<dynamic> getUserByDateApi(String houseId,var date) async {
    dynamic response = await _apiNetworkService.getApi("${ApiUrl.userApi}/get_user_by_house_and_date/$houseId?date=$date");
    return response;
  }

  Future<dynamic> updateDeviceTokenApi(int id, var token) async {
    await _apiNetworkService.putApi(
        {"deviceToken": token}, "${ApiUrl.userApi}/updateDeviceToken/$id");
  }
  Future<dynamic> updateInformationApi(User user) async {
    await _apiNetworkService.putApi(
        null, "${ApiUrl.userApi}/updateInformation/${user.id}/${user.username}/${user.email}");
  }
  Future<dynamic> leaveHouse( String houseId, int userId, var date) async{
    await _apiNetworkService.putApi(null,'${ApiUrl.userApi}/leaveHouse/$userId/$houseId?date=$date');
  }
  Future<dynamic> getUserByEmailApi(String email) async {
    dynamic response = await _apiNetworkService.getApi("${ApiUrl.userApi}/email/$email");
    return response;
  }
  Future<dynamic> checkUserByEmailApi(String email) async {
    dynamic response = await _apiNetworkService.getApi("${ApiUrl.userApi}/check/email/$email");
    return response;
  }
}
