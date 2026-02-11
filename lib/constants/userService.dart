import 'package:dio/dio.dart';
import 'package:logisticscustomer/constants/local_storage.dart';

class UserService {
  static Future<String?> getUserId() async {
    try {
      final token = await LocalStorage.getToken();
      if (token == null) return null;
      
      final dio = Dio();
      final response = await dio.get(
        'https://your-api.com/api/user/profile',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      
      if (response.statusCode == 200) {
        // Response structure ke hisaab se adjust karo
        return response.data['data']['id']?.toString() ?? 
               response.data['id']?.toString();
      }
      return null;
    } catch (e) {
      print('❌ Error getting user ID from API: $e');
      return null;
    }
  }
}