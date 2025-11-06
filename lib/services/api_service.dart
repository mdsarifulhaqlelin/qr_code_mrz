import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://your-backend.com/api';

  Future<Map<String, dynamic>> verifyUIN(String uin, String mobile) async {
    final response = await http.post(
      Uri.parse('$baseUrl/verify-uin'),
      body: {'uin': uin, 'mobile': mobile},
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> verifyOTP(String otp) async {
    final response = await http.post(
      Uri.parse('$baseUrl/verify-otp'),
      body: {'otp': otp},
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getCertificate(String uin, String mobile) async {
    final response = await http.post(
      Uri.parse('$baseUrl/get-certificate'),
      body: {'uin': uin, 'mobile': mobile},
    );
    return jsonDecode(response.body);
  }
}
