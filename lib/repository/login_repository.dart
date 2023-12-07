import '../data/network/network_api_service.dart';
import '../res/api_url.dart';

class LoginRepository {
  final _apiService = NetworkApiService();

  Future<dynamic> loginApi(String email) async {
    dynamic response = await _apiService.getApi('${ApiUrl.userApi}/$email');
    return response;
  }

  Future<dynamic> passwordCheckApi(String email, String password) async {
    dynamic response = await _apiService.getApi('${ApiUrl.loginApi}/$email/$password');
    return response;
  }
  Future<dynamic> emailCheckApi(String email) async {
    dynamic response = await _apiService.getApi('${ApiUrl.loginApi}/$email');
    return response;
  }
}