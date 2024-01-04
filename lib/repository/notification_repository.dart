import 'package:untitled1/data/network/network_api_service.dart';
import 'package:untitled1/res/api_url.dart';

class NotificationRepository{
  final _apiService = NetworkApiService();
  Future<dynamic> getNotificationByUser(int userId) async{
    return await _apiService.getApi('${ApiUrl.notificationApi}/getNotification/$userId');
  }
  Future<dynamic> getUnreadNotificationByUser(int userId) async{
    return await _apiService.getApi('${ApiUrl.notificationApi}/getUnreadNotification/$userId');
  }
  Future<dynamic> createNotification(var data) async{
    return await _apiService. postApi(data,'${ApiUrl.notificationApi}/create');
  }
  Future<dynamic> readNotification(int notificationId) async{
    return await _apiService.putApi(null,'${ApiUrl.notificationApi}/readNotification/$notificationId');
  }
}