import 'package:untitled1/data/network/network_api_service.dart';
import 'package:untitled1/res/api_url.dart';

class SignupRepository{
  final _apiService = NetworkApiService();
  Future<dynamic> signupAPI(var data) async {
    dynamic response = await _apiService.postApi(data,'${ApiUrl.signupApi}/success');
    return response;
  }
  Future<dynamic> emailCheckAPI(String email) async{
    dynamic response = await _apiService.getApi('${ApiUrl.signupApi}/$email');
    return !response;
  }
}