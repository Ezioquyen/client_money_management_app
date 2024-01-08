import 'package:untitled1/res/api_url.dart';

import '../data/network/network_api_service.dart';

class AnalyticRepository {
  final _apiNetworkService = NetworkApiService();
  Future<dynamic> getTotalFeeByMonth(String houseId, int userId) async{
    return await _apiNetworkService.getApi('${ApiUrl.analyticApi}/get_total_fee_by_month/$houseId/$userId');
  }
  Future<dynamic> getTotalPaidByMonth(String houseId, int userId) async{
     return await _apiNetworkService.getApi('${ApiUrl.analyticApi}/get_total_paid_by_month/$houseId/$userId');

  }
  Future<dynamic> getPaidForByMonth(String houseId, int userId, String date) async{
    return await _apiNetworkService.getApi('${ApiUrl.analyticApi}/get_paid_for_by_month/$houseId/$userId?date=$date');
  }
  Future<dynamic> getFeeFromByMonth(String houseId, int userId, String date) async{
    return await _apiNetworkService.getApi('${ApiUrl.analyticApi}/get_fee_from_by_month/$houseId/$userId?date=$date');
  }
  Future<dynamic> calculate(String houseId, String date) async{
    return await _apiNetworkService.getApi('${ApiUrl.analyticApi}/calculate/$houseId?date=$date');
  }

  
}