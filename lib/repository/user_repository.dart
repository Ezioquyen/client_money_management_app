import '../data/network/network_api_service.dart';
import '../res/api_url.dart';

class UserRepository {
  final _apiNetworkService = NetworkApiService();
  Future<dynamic> getUserApi(int id) async{
    dynamic response = await _apiNetworkService.getApi("${ApiUrl.userApi}/$id");
    return response;
  }
}