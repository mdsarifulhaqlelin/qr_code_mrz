import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://api.mrzaivs.com/web';

  bool isLoading = false;

  Future<Map<String, dynamic>> verifyUIN(String uin, String mobile) async {
    Map<String, dynamic> data = {};
    try {
      isLoading = true;
      final response = await http.post(
        Uri.parse('$baseUrl/validate'),
        body: {'uin': uin, 'mobile': mobile},
      );
      data = jsonDecode(response.body) as Map<String, dynamic>;

      print("========> UIN ==== ${data['message']}");
      print("========> TOKEN ====== ${data['token']}");
      print("========> APPICATION ID ===== ${data['applicationId']}");

      print(data);
      isLoading = false;
    } catch (e) {
      isLoading = false;
      debugPrint(e.toString());
    }
    return data;
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

// Model
class ValidateModel {
  bool? success;
  String? message;
  String? token;
  String? applicationId;
  String? uin;

  ValidateModel({
    this.message,
    this.success,
    this.token,
    this.applicationId,
    this.uin,
  });

  ValidateModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    token = json['token'];
    applicationId = json['applicationId'];
    uin = json['uin'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['token'] = token;
    data['applicationId'] = applicationId;
    data['uin'] = uin;
    return data;
  }
}
